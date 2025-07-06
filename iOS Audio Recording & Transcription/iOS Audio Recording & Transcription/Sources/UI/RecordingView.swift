import SwiftUI

struct RecordingView: View {
    @State private var isRecording = false
    @State private var engineManager: AudioEngineManager?
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack {
            Text(isRecording ? "Recording..." : "Ready to Record")
                .font(.title)

            Button(action: {
                if isRecording {
                    engineManager?.stopRecording()
                    isRecording = false
                } else {
                    startRecording()
                }
            }) {
                Text(isRecording ? "Stop" : "Start Recording")
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    func startRecording() {
        let audioSessionManager = AudioSessionManager()
        audioSessionManager.configureSession()

        let repo = SessionRepository(context: context)
        let session = repo.createSession()

        let outputDir = FileManager.default.temporaryDirectory
        let manager = AudioEngineManager(outputDirectory: outputDir)
        engineManager = manager

        manager.onSegmentCompleted = { fileURL in
            let segment = repo.addSegment(to: session, fileURL: fileURL)
            Task {
                let transcriptionService = TranscriptionService()
                do {
                    let text = try await transcriptionService.transcribe(fileURL: fileURL)
                    repo.updateSegment(segment, transcription: text, status: .success)
                } catch {
                    repo.updateSegment(segment, transcription: "Failed", status: .failure)
                }
            }
        }

        do {
            try manager.startRecording()
            isRecording = true
        } catch {
            print("Failed starting recording: \(error)")
        }
    }
}
