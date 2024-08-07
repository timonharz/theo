//
//  File.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import Foundation
import AVFoundation
import SoundAnalysis
import Combine

final class SystemAudioClassifier: NSObject {
  /// Errors that can occur during system audio classification.
  enum SystemAudioClassificationError: Error {
      // Indicates interruption in the audio stream.
      case audioStreamInterrupted
      // Indicates lack of microphone access.
      case noMicrophoneAccess
  }

  /// A queue for performing analysis tasks related to system audio classification.
  private let analysisQueue = DispatchQueue(label: "com.TimonHarz.theo.AnalysisQueue")

  /// The AVAudioEngine used for audio processing.
  private var audioEngine: AVAudioEngine?

  /// The SNAudioStreamAnalyzer used for analyzing audio streams.
  private var analyzer: SNAudioStreamAnalyzer?

  /// A list of retained observers for SNResultsObserving.
  private var retainedObservers: [SNResultsObserving]?

  /// A subject for publishing SNClassificationResult.
  private var subject: PassthroughSubject<SNClassificationResult, Error>?

  /// A singleton instance of the SystemAudioClassifier.
  private override init() {}

  /// The singleton instance of the SystemAudioClassifier.
  static let singleton = SystemAudioClassifier()

  /// Ensure microphone access for audio processing.
  /// - Throws: SystemAudioClassificationError.noMicrophoneAccess if microphone access is not granted.
  private func ensureMicrophoneAccess() throws {
      var hasMicrophoneAccess = false

      // Check the authorization status for microphone access
      switch AVCaptureDevice.authorizationStatus(for: .audio) {
      case .notDetermined:
          // Request microphone access if it has not been determined yet
          let sem = DispatchSemaphore(value: 0)
          AVCaptureDevice.requestAccess(for: .audio) { success in
              hasMicrophoneAccess = success
              sem.signal()
          }
          _ = sem.wait(timeout: DispatchTime.distantFuture)
      case .denied, .restricted:
          // Microphone access is denied or restricted
          break
      case .authorized:
          // Microphone access is authorized
          hasMicrophoneAccess = true
      @unknown default:
          // Handle unknown authorization status
          fatalError("unknown authorization status for microphone access")
      }

      // Throw an error if microphone access is not granted
      if !hasMicrophoneAccess {
          throw SystemAudioClassificationError.noMicrophoneAccess
      }
  }


  /// Start the audio session for audio recording.
  /// - Throws: An error if starting the audio session fails.
  private func startAudioSession() throws {
      // Ensure that any existing audio session is stopped before starting a new one
      stopAudioSession()
      do {
          // Create a new audio session and set its category and mode
          let audioSession = AVAudioSession.sharedInstance()
          try audioSession.setCategory(.record, mode: .default)

          // Activate the audio session
          try audioSession.setActive(true)
      } catch {
          // If starting the audio session fails, ensure that it is stopped and rethrow the error
          stopAudioSession()
          throw error
      }
  }

  /// Stop the audio session, deactivating it.
  private func stopAudioSession() {
      // Use autoreleasepool to release any temporary objects created during deactivation
      autoreleasepool {
          let audioSession = AVAudioSession.sharedInstance()
          // Attempt to deactivate the audio session and ignore any errors
          try? audioSession.setActive(false)
      }
  }

  /// Start listening for audio session interruptions and media services loss.
  private func startListeningForAudioSessionInterruptions() {
      // Add observers for audio session interruptions and media services loss
      NotificationCenter.default.addObserver(
          self,
          selector: #selector(handleAudioSessionInterruption),
          name: AVAudioSession.interruptionNotification,
          object: nil)
      NotificationCenter.default.addObserver(
          self,
          selector: #selector(handleAudioSessionInterruption),
          name: AVAudioSession.mediaServicesWereLostNotification,
          object: nil)
  }


  /// Stop listening for audio session interruptions and media services loss.
  private func stopListeningForAudioSessionInterruptions() {
      // Remove observers for audio session interruptions and media services loss
      NotificationCenter.default.removeObserver(
          self,
          name: AVAudioSession.interruptionNotification,
          object: nil)
      NotificationCenter.default.removeObserver(
          self,
          name: AVAudioSession.mediaServicesWereLostNotification,
          object: nil)
  }


  /// Handle audio session interruption notification.
  /// - Parameter notification: The notification object containing information about the interruption.
  @objc
  private func handleAudioSessionInterruption(_ notification: Notification) {
      // Send a failure completion to the subject indicating audio stream interruption
      let error = SystemAudioClassificationError.audioStreamInterrupted
      subject?.send(completion: .failure(error))
      // Stop the sound classification process
      stopSoundClassification()
  }


  /// Start analyzing audio input with specified requests and observers.
  /// - Parameter requestsAndObservers: A tuple array containing requests and observers.
  /// - Throws: An error if starting the analysis process fails.
  private func startAnalyzing(_ requestsAndObservers: [(SNRequest, SNResultsObserving)]) throws {
      // Stop any ongoing analysis process
      stopAnalyzing()

      do {
          // Start the audio session
          try startAudioSession()

          // Ensure microphone access
          try ensureMicrophoneAccess()

          // Create a new AVAudioEngine for audio processing
          let newAudioEngine = AVAudioEngine()
          audioEngine = newAudioEngine

          // Get the audio input format from the input node of the audio engine
          let busIndex = AVAudioNodeBus(0)
          let bufferSize = AVAudioFrameCount(4096)
          let audioFormat = newAudioEngine.inputNode.outputFormat(forBus: busIndex)

          // Create a new SNAudioStreamAnalyzer with the audio format
          let newAnalyzer = SNAudioStreamAnalyzer(format: audioFormat)
          analyzer = newAnalyzer

          // Add requests and observers to the analyzer
          try requestsAndObservers.forEach { try newAnalyzer.add($0.0, withObserver: $0.1) }
          retainedObservers = requestsAndObservers.map { $0.1 }

          // Install a tap on the input node to capture audio data
          newAudioEngine.inputNode.installTap(
              onBus: busIndex,
              bufferSize: bufferSize,
              format: audioFormat,
              block: { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                  self.analysisQueue.async {
                      newAnalyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
                  }
              })

          // Start the audio engine
          try newAudioEngine.start()
      } catch {
          // If any error occurs, stop the analysis process and rethrow the error
          stopAnalyzing()
          throw error
      }
  }

  /// Stop the analysis process.
  private func stopAnalyzing() {
      // Use autoreleasepool to release any temporary objects created during the process
      autoreleasepool {
          // Stop the audio engine and remove the tap from the input node
          if let audioEngine = audioEngine {
              audioEngine.stop()
              audioEngine.inputNode.removeTap(onBus: 0)
          }

          // Remove all requests from the analyzer
          if let analyzer = analyzer {
              analyzer.removeAllRequests()
          }

          // Reset analyzer, retainedObservers, and audioEngine references to nil
          analyzer = nil
          retainedObservers = nil
          audioEngine = nil
      }

      // Stop the audio session
      stopAudioSession()
  }
  /// Start sound classification with specified parameters.
  /// - Parameters:
  ///   - subject: A PassthroughSubject to publish classification results.
  ///   - inferenceWindowSize: The duration of the analysis window in seconds.
  ///   - overlapFactor: The overlap factor for consecutive analysis windows.
  func startSoundClassification(subject: PassthroughSubject<SNClassificationResult, Error>,
                                inferenceWindowSize: Double,
                                overlapFactor: Double) {
      // Stop any ongoing sound classification process
      stopSoundClassification()

      do {
          // Create a new observer for classification results
          let observer = ClassificationResultsSubject(subject: subject)

          // Create a sound classification request
          let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
          request.windowDuration = CMTimeMakeWithSeconds(inferenceWindowSize, preferredTimescale: 48_000)
          request.overlapFactor = overlapFactor

          // Set the subject for publishing classification results
          self.subject = subject

          // Start listening for audio session interruptions
          startListeningForAudioSessionInterruptions()

          // Start analyzing audio input with the sound classification request and observer
          try startAnalyzing([(request, observer)])
      } catch {
          // Send a failure completion to the subject if an error occurs
          subject.send(completion: .failure(error))
          self.subject = nil
          // Stop the sound classification process
          stopSoundClassification()
      }
  }
  /// Stop the sound classification process.
  func stopSoundClassification() {
      // Stop analyzing audio input
      self.stopAnalyzing()
      // Stop listening for audio session interruptions
      self.stopListeningForAudioSessionInterruptions()
      // Stop the audio engine if it exists
      self.audioEngine?.stop()
  }

  /// Retrieve all possible labels from the sound classifier.
  /// - Returns: A set containing all possible labels.
  /// - Throws: An error if retrieving the labels fails.
  static func getAllPossibleLabels() throws -> Set<String> {
      // Create a sound classification request to access known classifications
      let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
      // Return a set containing all known classifications
      return Set<String>(request.knownClassifications)
  }
}

