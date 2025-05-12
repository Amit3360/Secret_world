import Foundation
import AVFoundation

class AudioRecorder {
    private var audioEngine = AVAudioEngine()
    private var audioRecorder: AVAudioRecorder?
    private var audioFileURL: URL?
    var onAudioLevelUpdate: ((CGFloat) -> Void)?
    var audioUrl: ((URL) -> Void)?
  
    private var avPlayer: AVPlayer?
    func startRecording() {
        // First configure the audio session
        configureAudioSession()

        // Delete the previous recording file if it exists
        if let existingURL = audioFileURL {
            deleteFile(at: existingURL)
        }

        audioFileURL = getAudioFileURL() // Set new file URL before starting
        guard let fileURL = audioFileURL else { return } // Ensure it's not nil

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            if audioRecorder?.prepareToRecord() ?? false {
                audioRecorder?.record()
            } else {
                print("Failed to prepare recorder.")
            }
        } catch {
            print("Error initializing audio recorder: \(error.localizedDescription)")
        }

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.processAudio(buffer: buffer)
        }

        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    // Add this new method
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
    }


    func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        audioRecorder?.stop()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let fileURL = self.audioFileURL {
                self.audioUrl?(fileURL)
            }
        }
    }

    private func processAudio(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))

        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
        let level = CGFloat(rms * 100)

        DispatchQueue.main.async {
            self.onAudioLevelUpdate?(level)
        }
    }

     func getAudioFileURL() -> URL {
        let fileName = "recording_\(Date().timeIntervalSince1970).m4a"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }

    func deleteFile(at url: URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
                print("Previous audio file deleted successfully.")
            } catch {
                print("Error deleting previous audio file: \(error.localizedDescription)")
            }
        }
    }
}
