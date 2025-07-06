import Foundation
import AVFoundation

class AudioEngineManager {
    private let engine = AVAudioEngine()
    private var fileWriter: AVAudioFile?
    private var timer: Timer?
    private var segmentDuration: TimeInterval = 30
    private var outputDirectory: URL
    private var currentSegmentStartDate: Date?
    var onSegmentCompleted: ((URL) -> Void)?

    
    
    init(outputDirectory: URL) {
        self.outputDirectory = outputDirectory
    }

    func startRecording() throws {
        let inputNode = engine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        let fileURL = nextFileURL()
        fileWriter = try AVAudioFile(forWriting: fileURL, settings: format.settings)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            do {
                try self.fileWriter?.write(from: buffer)
            } catch {
                print("Error writing audio: \(error)")
            }
        }

        engine.prepare()
        try engine.start()
        currentSegmentStartDate = Date()

        timer = Timer.scheduledTimer(withTimeInterval: segmentDuration, repeats: true) { [weak self] _ in
            self?.rotateSegment()
        }
    }

    func stopRecording() {
        timer?.invalidate()
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        completeSegment()
    }

    private func rotateSegment() {
        completeSegment()
        do {
            let inputNode = engine.inputNode
            let format = inputNode.outputFormat(forBus: 0)
            let newURL = nextFileURL()
            fileWriter = try AVAudioFile(forWriting: newURL, settings: format.settings)
            currentSegmentStartDate = Date()
        } catch {
            print("Failed rotating file: \(error)")
        }
    }

    private func completeSegment() {
        if let fileURL = fileWriter?.url {
            onSegmentCompleted?(fileURL)
        }
        fileWriter = nil
    }

    private func nextFileURL() -> URL {
        return outputDirectory.appendingPathComponent(UUID().uuidString + ".wav")
    }
}
