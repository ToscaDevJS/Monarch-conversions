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
                    Text("System notifications for completed files")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
                
                Spacer()
                
                Toggle("Notify when a conversion finishes", isOn: $settings.notifyOnFinish)
                    .labelsHidden()
                    .toggleStyle(.switch)
                    .tint(MonarchUI.Color.accentViolet)
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
