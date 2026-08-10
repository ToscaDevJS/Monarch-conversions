import SwiftUI

struct GlobalSearchBarView: View {
    @Binding var searchText: String
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(MonarchUI.Color.textSecondary)
            
            TextField(String(localized: "search.placeholder", table: "Common"), text: $searchText)
                .textFieldStyle(.plain)
                .font(MonarchUI.Font.sans(size: 15))
                .foregroundStyle(MonarchUI.Color.textPrimary)
                .focused($isSearchFocused)
            
            Spacer()
            
            Button {
                isSearchFocused = true
            } label: {
                HStack(spacing: 2) {
                    Text("⌘K")
                        .font(MonarchUI.Font.mono(size: 11, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    Rectangle()
                        .fill(MonarchUI.Color.shortcutBg)
                )
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .keyboardShortcut("k", modifiers: .command)
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(MonarchUI.Color.searchBg)
        .overlay(
            Rectangle()
                .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
        )
    }
}

#Preview {
    GlobalSearchBarView(searchText: .constant(""))
        .padding()
        .background(MonarchUI.Color.background)
}
