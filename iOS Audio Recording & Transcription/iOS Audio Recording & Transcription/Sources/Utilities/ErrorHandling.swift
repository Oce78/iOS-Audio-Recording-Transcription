import Foundation

enum AudioAppError: Error {
    case permissionDenied
    case storageFull
    case transcriptionFailed
}
