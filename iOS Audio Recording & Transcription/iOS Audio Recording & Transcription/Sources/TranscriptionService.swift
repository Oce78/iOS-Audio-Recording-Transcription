import Foundation

class TranscriptionService {
    func transcribe(fileURL: URL) async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "Transcribed text for \(fileURL.lastPathComponent)"
    }
}
