import SwiftUI
import SwiftData

struct ConvertScene: View {
    var onSelectTab: ((AppTab) -> Void)? = nil

    @Environment(\.modelContext) private var modelContext

    @State private var items: [BatchQueueItem] = []
    @State private var rejections: [ImportRejection] = []
    @State private var selectedId: UUID? = nil
    @State private var conversionSettings = ConversionSettings(targetFormat: .png, quality: 0.82)
    @State private var isProcessing: Bool = false

    private let importService = ImageImportService()
    private let conversionService = ImageConversionService()

    var selectedItem: BatchQueueItem? {
        if let selectedId = selectedId {
            return items.first(where: { $0.id == selectedId })
        }
        return items.first
    }

    private var originalSizeText: String {
        guard let item = selectedItem else { return "ORIGINAL: —" }
        return "ORIGINAL: \(ConversionFormatting.byteSize(item.originalSizeBytes))"
    }

    private var targetFormatText: String {
        guard let item = selectedItem, let targetFormat = item.targetFormat else { return "NO TARGET" }
        return "\(targetFormat.rawValue.uppercased()) OPTIMIZED"
    }

    private var targetSizeText: String {
        guard let item = selectedItem,
              let targetFormat = item.targetFormat,
              let targetBytes = item.targetSizeBytes,
              let pct = item.reductionPercent else {
            return "NO TARGET YET"
        }
        let formatStr = targetFormat.rawValue.uppercased()
        let sizeStr = ConversionFormatting.byteSize(targetBytes)
        let pctStr = ConversionFormatting.reduction(percent: pct)
        return "\(formatStr): \(sizeStr) (\(pctStr))"
    }

    private func handleImport(_ urls: [URL]) {
        guard !urls.isEmpty else { return }
        Task {
            let outcomes = await importService.importFiles(at: urls, existingCount: items.count)
            var newAccepted: [BatchQueueItem] = []
            var newRejections: [ImportRejection] = []
            for outcome in outcomes {
                switch outcome {
                case .accepted(let item):
                    newAccepted.append(item)
                case .rejected(let rejection):
                    newRejections.append(rejection)
                }
            }
            items.append(contentsOf: newAccepted)
            rejections = newRejections
            if selectedId == nil {
                selectedId = items.first?.id
            }
        }
    }

    private func processBatchConversion() {
        guard !items.isEmpty, !isProcessing else { return }
        let pendingItemIDs = BatchQueueProcessor.pendingItems(in: items).map { $0.id }
        guard !pendingItemIDs.isEmpty else { return }
        isProcessing = true

        Task {
            for targetId in pendingItemIDs {
                guard let index = items.firstIndex(where: { $0.id == targetId }),
                      items[index].status == .queued,
                      let sourceURL = items[index].fileURL else { continue }
                let item = items[index]
                items[index].status = .converting

                do {
                    let result = try await conversionService.convert(sourceURL: sourceURL, settings: conversionSettings)

                    let updatedItem = BatchQueueItem(
                        id: item.id,
                        name: item.name,
                        format: item.format,
                        dimensions: item.dimensions,
                        originalSizeBytes: item.originalSizeBytes,
                        targetFormat: conversionSettings.targetFormat,
                        targetSizeBytes: result.outputSizeBytes,
                        fileURL: item.fileURL,
                        outputFileURL: result.outputURL,
                        status: .done,
                        isFallbackDestination: result.wasFallback
                    )
                    if let currentIndex = items.firstIndex(where: { $0.id == targetId }) {
                        items[currentIndex] = updatedItem
                    }

                    let record = ConversionRecord(
                        fileId: item.id.uuidString,
                        fileName: item.name,
                        inputFormat: item.format,
                        dimensions: result.outputDimensions,
                        outputFormat: conversionSettings.targetFormat,
                        outputSizeBytes: result.outputSizeBytes,
                        project: "Default",
                        status: .done,
                        timestamp: Date(),
                        outputFilePath: result.outputURL.path
                    )
                    modelContext.insert(record)
                } catch {
                    if let currentIndex = items.firstIndex(where: { $0.id == targetId }) {
                        items[currentIndex].status = .failed
                    }
                    print("Conversion failed for \(item.name): \(error.localizedDescription)")
                }
            }

            try? modelContext.save()
            isProcessing = false
        }
    }

    private func deleteSelectedItem() {
        guard !isProcessing else { return }
        guard let currentId = selectedId,
              let index = items.firstIndex(where: { $0.id == currentId }) else { return }
        items.remove(at: index)
        selectedId = items.first?.id
    }

    private func clearQueue() {
        guard !isProcessing else { return }
        items.removeAll()
        selectedId = nil
        rejections.removeAll()
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TopNavHeaderView(activeTab: .convert, onSelectTab: onSelectTab)

                ConvertHeadingView()

                HStack(alignment: .top, spacing: 24) {
                    // Left Column (Dropzone & Batch Queue)
                    VStack(alignment: .leading, spacing: 20) {
                        BatchDropzoneView(
                            onBrowse: {
                                let urls = ImageFilePicker.pickFiles()
                                handleImport(urls)
                            },
                            onDropFiles: { urls in
                                handleImport(urls)
                            }
                        )

                        ImportRejectionListView(
                            rejections: rejections,
                            onDismiss: {
                                rejections.removeAll()
                            }
                        )

                        BatchQueueView(
                            items: $items,
                            selectedId: $selectedId,
                            onClearAll: {
                                clearQueue()
                            }
                        )
                    }
                    .frame(width: 460)

                    // Right Column (Visual Inspector & Output Settings)
                    VStack(alignment: .leading, spacing: 20) {
                        SquooshInspectorView(
                            fileName: selectedItem?.name ?? "No file selected",
                            originalSizeText: originalSizeText,
                            targetFormatText: targetFormatText,
                            targetSizeText: targetSizeText,
                            imageURL: selectedItem?.fileURL,
                            outputImageURL: selectedItem?.outputFileURL
                        )

                        OutputSettingsView(
                            settings: $conversionSettings,
                            isProcessing: isProcessing,
                            onAddBatch: {
                                processBatchConversion()
                            }
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 24)
            }
            .padding(28)
            .background(MonarchUI.Color.background)

            Spacer(minLength: 0)

            BatchStatusFooterView(
                items: items,
                settings: conversionSettings,
                isProcessing: isProcessing
            )
        }
        .background(MonarchUI.Color.background)
        .background {
            Group {
                Button("Import Images") {
                    let urls = ImageFilePicker.pickFiles()
                    handleImport(urls)
                }
                .keyboardShortcut("o", modifiers: .command)

                Button("Start Batch") {
                    processBatchConversion()
                }
                .keyboardShortcut("r", modifiers: .command)

                Button("Start Batch Return") {
                    processBatchConversion()
                }
                .keyboardShortcut(.return, modifiers: .command)

                Button("Delete Selected") {
                    deleteSelectedItem()
                }
                .keyboardShortcut(.delete, modifiers: .command)

                Button("Clear Queue") {
                    clearQueue()
                }
                .keyboardShortcut("k", modifiers: .command)
            }
            .opacity(0)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            if selectedId == nil {
                selectedId = items.first?.id
            }
        }
    }
}

#Preview {
    ConvertScene()
}
