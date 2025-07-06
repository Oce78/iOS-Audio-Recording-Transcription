import SwiftUI
import SwiftData

@main
struct AudioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [RecordingSession.self, RecordingSegment.self])
    }
}
