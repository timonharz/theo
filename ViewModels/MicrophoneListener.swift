//
//  File.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import Foundation
import AVFoundation

protocol MicrophoneListenerDelegate: AnyObject {
    func didDetectSpeech()
    func didNotDetectSpeech()
}

class MicrophoneListener: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder!
    private var isListening = false
    weak var delegate: MicrophoneListenerDelegate?

    override init() {
        super.init()
        self.setupAudioSession()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }

    func startListening() {
        guard !isListening else { return }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 41000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()!,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            isListening = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.detectSpeech()
            }
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    private func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.caf")
        return soundURL
    }

    private func detectSpeech() {
        guard isListening else { return }

        audioRecorder.updateMeters()
        let averagePower = audioRecorder.averagePower(forChannel: 0)

        if averagePower > -30 { // You can adjust this threshold according to your needs
            delegate?.didDetectSpeech()
        } else {
            delegate?.didNotDetectSpeech()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.detectSpeech()
        }
    }

    func stopListening() {
        guard isListening else { return }

        audioRecorder.stop()
        isListening = false
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Audio recording finished successfully.")
        } else {
            print("Audio recording failed.")
        }
    }
}
