import SwiftUI

struct SessionListView: View {
    @Query(sort: \RecordingSession.startDate, order: .reverse) var sessions: [RecordingSession]

    var body: some View {
        List(sessions) { session in
            NavigationLink {
                SessionDetailView(session: session)
            } label: {
                Text("Session on \(session.startDate.formatted())")
            }
        }
    }
}
