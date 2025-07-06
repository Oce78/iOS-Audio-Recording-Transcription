import AVFoundation

class AudioSessionManager {
    func configureSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord,
                                    mode: .default,
                                    options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }

        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: session,
            queue: .main) { notification in
                self.handleInterruption(notification: notification)
            }

        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: session,
            queue: .main) { notification in
                self.handleRouteChange(notification: notification)
            }
    }

    private func handleInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch type {
        case .began:
            print("Interruption began")
        case .ended:
            print("Interruption ended")
            try? AVAudioSession.sharedInstance().setActive(true)
        @unknown default:
            break
        }
    }

    private func handleRouteChange(notification: Notification) {
        print("Audio route changed")
    }
}
