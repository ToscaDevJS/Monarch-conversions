import SwiftUI

struct AboutPanelView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.28.0"
    }

    private var appBuild: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "28"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header: Icon + Info
            HStack(spacing: 20) {
                if let appIconImage = NSImage(named: "AppIcon") ?? NSApp.applicationIconImage {
                    Image(nsImage: appIconImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
                        )
                        .shadow(color: SwiftUI.Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text("Monarch")
                            .font(MonarchUI.Font.sans(size: 22, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.textPrimary)

                        Text("v\(appVersion) (\(appBuild))")
                            .font(MonarchUI.Font.mono(size: 12, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(MonarchUI.Color.accentVioletBg)
                            .clipShape(Capsule())
                    }

                    Text("High-performance native image batch converter & optimizer for macOS.")
                        .font(MonarchUI.Font.sans(size: 13))
                        .foregroundStyle(MonarchUI.Color.textSecondary)
                }
            }

            Divider()
                .background(MonarchUI.Color.divider)

            // Privacy & Architecture Card
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(MonarchUI.Color.statusGreen)

                    Text("Privacy & Security Guarantee")
                        .font(MonarchUI.Font.sans(size: 14, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }

                Text("Monarch runs 100% locally on your Mac using hardware-accelerated Apple ImageIO and CoreGraphics frameworks. No images, telemetry, or personal data ever leave your machine.")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                    .lineSpacing(3)
            }
            .padding(16)
            .background(MonarchUI.Color.cardDarkBg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
            )

            // Quick Links
            VStack(alignment: .leading, spacing: 10) {
                Text("Resources & Links")
                    .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)

                HStack(spacing: 12) {
                    Link(destination: URL(string: "https://github.com/ToscaDevJS/Monarch-conversions")!) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                .font(.system(size: 11))
                            Text("GitHub Repository")
                                .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(MonarchUI.Color.shortcutBg)
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .buttonStyle(.plain)

                    Link(destination: URL(string: "https://github.com/ToscaDevJS/Monarch-conversions/issues")!) {
                        HStack(spacing: 6) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 11))
                            Text("Support & Feedback")
                                .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(MonarchUI.Color.shortcutBg)
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()
                .background(MonarchUI.Color.divider)

            // Copyright
            Text("Copyright © 2026 ToscaDev. All rights reserved.")
                .font(MonarchUI.Font.sans(size: 11))
                .foregroundStyle(MonarchUI.Color.textDim)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    AboutPanelView()
        .padding()
        .background(MonarchUI.Color.background)
}
