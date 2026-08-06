import SwiftUI

struct WorkflowPanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Workflow")
                    .font(MonarchUI.Font.sans(size: 16, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("Fine-tune small details that speed up everyday conversion work.")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Notify when a conversion finishes")
                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    Text("Browser/OS notifications for completed files")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textSecondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $settings.notifyOnFinish)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: MonarchUI.Color.accentViolet))
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(
            Rectangle()
                .fill(MonarchUI.Color.surface)
        )
        .overlay(
            Rectangle()
                .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
        )
    }
}

#Preview {
    WorkflowPanelView(settings: UserSettings())
        .padding()
        .background(MonarchUI.Color.background)
}
