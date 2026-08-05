import SwiftUI

struct GlobalSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(MonarchUI.Color.textSecondary)
            
            TextField("Search images, file names, projects or formats", text: $searchText)
                .textFieldStyle(.plain)
                .font(MonarchUI.Font.sans(size: 15))
                .foregroundStyle(MonarchUI.Color.textPrimary)
            
            Spacer()
            
            HStack(spacing: 2) {
                Text("⌘K")
                    .font(MonarchUI.Font.mono(size: 11, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(MonarchUI.Color.shortcutBg)
            )
        }
        .padding(.horizontal, 12)
        .frame(height: 48)
        .background(MonarchUI.Color.searchBg)
        .overlay(
            Rectangle()
                .stroke(SwiftUI.Color(hex: "#1B1B1B"), lineWidth: 1)
        )
    }
}

#Preview {
    GlobalSearchBarView(searchText: .constant(""))
        .padding()
        .background(MonarchUI.Color.background)
}
