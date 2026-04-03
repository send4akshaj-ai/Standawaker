import SwiftUI

@main
struct StandawakerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var wakeManager = WakeManager()

    var body: some Scene {
        WindowGroup {
            StandbyView()
                .environmentObject(wakeManager)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
                .onAppear {
                    wakeManager.applyCurrentSetting()
                }
                .onChange(of: scenePhase) { newPhase in
                    wakeManager.handleScenePhaseChange(newPhase)
                }
        }
    }
}
