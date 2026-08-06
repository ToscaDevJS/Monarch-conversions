import SwiftUI

struct WorkflowPanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Workflow")
                    .font(MonarchUI.Font.sans(size: 18, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("Fine-tune small details that speed up everyday conversion work.")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSubtle)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Notify when a conversion finishes")
                        .font(MonarchUI.Font.sans(size: 14))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    Text("Browser notifications for completed files")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
                
                Spacer()
                
                Button {
                    settings.notifyOnFinish.toggle()
                } label: {
                    HStack {
                        if !settings.notifyOnFinish { Spacer() }
                        Rectangle()
                            .fill(settings.notifyOnFinish ? MonarchUI.Color.accentVioletBg : MonarchUI.Color.textMuted)
                            .frame(width: 16, height: 16)
                        if settings.notifyOnFinish { Spacer() }
                    }
                    .padding(2)
                    .frame(width: 36, height: 20)
                    .background(settings.notifyOnFinish ? MonarchUI.Color.accentViolet : SwiftUI.Color(hex: "#292929"))
                }
                .buttonStyle(.plain)
            }
            .frame(height: 36)
        }
        .padding(.top, 24)
    }
}

#Preview {
    WorkflowPanelView(settings: UserSettings())
        .padding()
        .background(MonarchUI.Color.background)
}
