import SwiftUI
import UIKit

final class WakeManager: ObservableObject {
    @AppStorage("forceAlwaysOnScreen") var forceAlwaysOnScreen: Bool = true {
        didSet {
            applyCurrentSetting()
        }
    }

    @AppStorage("keepScreenAwake") var keepScreenAwake: Bool = true {
        didSet {
            applyCurrentSetting()
        }
    }

    func applyCurrentSetting() {
        UIApplication.shared.isIdleTimerDisabled = forceAlwaysOnScreen || keepScreenAwake
    }

    func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            applyCurrentSetting()
        default:
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
