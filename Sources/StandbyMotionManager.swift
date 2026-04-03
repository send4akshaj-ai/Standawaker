import CoreMotion
import SwiftUI

final class StandbyMotionManager: ObservableObject {
    @Published var pitch: CGFloat = 0
    @Published var roll: CGFloat = 0

    private let motionManager = CMMotionManager()

    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let attitude = motion?.attitude else { return }
            self.pitch = CGFloat(attitude.pitch)
            self.roll = CGFloat(attitude.roll)
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        pitch = 0
        roll = 0
    }
}
