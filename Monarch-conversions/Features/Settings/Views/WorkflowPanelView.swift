import SwiftUI

struct WorkflowPanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("workflow.title", tableName: "Settings")
                    .font(MonarchUI.Font.sans(size: 18, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("workflow.subtitle", tableName: "Settings")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSubtle)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("workflow.notify_finish", tableName: "Settings")
                        .font(MonarchUI.Font.sans(size: 14))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    Text("workflow.notify_finish_subtitle", tableName: "Settings")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
                
                Spacer()
                
                Toggle(String(localized: "workflow.notify_finish", table: "Settings"), isOn: $settings.notifyOnFinish)
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
