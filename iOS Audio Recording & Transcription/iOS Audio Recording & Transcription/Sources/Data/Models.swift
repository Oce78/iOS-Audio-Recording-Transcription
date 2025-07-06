import Foundation
import SwiftData

@Model
class RecordingSession {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var endDate: Date?
    @Relationship(deleteRule: .cascade) var segments: [RecordingSegment]

    init(id: UUID = UUID(), startDate: Date, endDate: Date? = nil, segments: [RecordingSegment] = []) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.segments = segments
    }
}

@Model
class RecordingSegment {
    @Attribute(.unique) var id: UUID
    var fileURL: URL
    var transcription: String?
    var transcriptionStatus: TranscriptionStatus
    var retryCount: Int
    var createdAt: Date

    init(id: UUID = UUID(),
         fileURL: URL,
         transcription: String? = nil,
         transcriptionStatus: TranscriptionStatus = .pending,
         retryCount: Int = 0,
         createdAt: Date = Date()) {
        self.id = id
        self.fileURL = fileURL
        self.transcription = transcription
        self.transcriptionStatus = transcriptionStatus
        self.retryCount = retryCount
        self.createdAt = createdAt
    }
}

enum TranscriptionStatus: String, Codable, CaseIterable {
    case pending
    case transcribing
    case success
    case failure
}
