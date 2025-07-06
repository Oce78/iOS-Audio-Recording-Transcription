import SwiftUI

struct SessionDetailView: View {
    let session: RecordingSession

    var body: some View {
        List(session.segments) { segment in
            VStack(alignment: .leading) {
                Text(segment.transcription ?? "(no transcription)")
                    .font(.body)
                Text(segment.transcriptionStatus.rawValue)
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
        .navigationTitle("Session Details")
    }
}
