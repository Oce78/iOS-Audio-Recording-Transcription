import Foundation
import SwiftData

class SessionRepository {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func createSession() -> RecordingSession {
        let session = RecordingSession(startDate: Date())
        context.insert(session)
        return session
    }

    func addSegment(to session: RecordingSession, fileURL: URL) -> RecordingSegment {
        let segment = RecordingSegment(fileURL: fileURL)
        session.segments.append(segment)
        context.insert(segment)
        try? context.save()
        return segment
    }

    func updateSegment(_ segment: RecordingSegment, transcription: String, status: TranscriptionStatus) {
        segment.transcription = transcription
        segment.transcriptionStatus = status
        try? context.save()
    }

    func fetchAllSessions() -> [RecordingSession] {
        let fetchDescriptor = FetchDescriptor<RecordingSession>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
}
