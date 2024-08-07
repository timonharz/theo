//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import AVFoundation
import Foundation
import Speech
import SwiftUI

class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable

        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }

    @Published var transcript: String = ""
    @Published var transcriptionEnded: Bool = false

    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?

    init() {
        recognizer = SFSpeechRecognizer()

        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
        }
    }

  func transcribe() {
    print("transcription started")
      DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
          guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
              self?.speakError(RecognizerError.recognizerIsUnavailable)
              return
          }

          do {
              let (audioEngine, request) = try Self.prepareEngine()
              self.audioEngine = audioEngine
              self.request = request
              self.request?.requiresOnDeviceRecognition = true
              self.request?.shouldReportPartialResults = true

              self.task = recognizer.recognitionTask(with: request) { result, error in
                  let receivedFinalResult = result?.isFinal ?? false
                  let receivedError = error != nil

                  if receivedFinalResult || receivedError {
                      audioEngine.stop()
                      audioEngine.inputNode.removeTap(onBus: 0)
                      self.transcriptionEnded = true

                      if receivedFinalResult {
                          // Transcription has ended
                        self.transcriptionEnded = true
                          print("Transcription ended")
                      }
                  }

                  if let result = result {
                      self.speak(result.bestTranscription.formattedString)
                    self.transcriptionEnded = true
                    print("Transcription ended")

                  }
              }
          } catch {
              self.reset()
              self.speakError(error)
          }
      }
  }


    private func speak(_ message: String) {
        transcript = message
    }

    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()

        return (audioEngine, request)
    }

    func stopTranscribing() {
        reset()
    }

    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "Error transcribing"
    }

    func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }

    deinit {
        reset()
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
