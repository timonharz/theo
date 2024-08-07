//
//  File.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import Foundation
import SwiftUI
import Combine
import SoundAnalysis


struct SpeechDetection {

    var inferenceWindowSize = Double(1.5)

    var overlapFactor = Double(0.9)

    var monitoredSounds = Set<SoundIdentifier>()

    static func listAllValidSoundIdentifiers() throws -> Set<SoundIdentifier> {
        let labels = try SystemAudioClassifier.getAllPossibleLabels()
        return Set<SoundIdentifier>(labels.map {
            SoundIdentifier(labelName: $0)
        })
    }

}


class SpeechState: ObservableObject {

  private var detectionCancellable: AnyCancellable? = nil


  private var appConfig = SpeechDetection()


  @Published var detectionStates: [(SoundIdentifier, DetectionState)] = []


  @Published var soundDetectionIsRunning: Bool = false

  func restartDetection(config: SpeechDetection) {
    guard AppState().activeListeningOn else { return }
      SystemAudioClassifier.singleton.stopSoundClassification()

      let classificationSubject = PassthroughSubject<SNClassificationResult, Error>()

      detectionCancellable =
        classificationSubject
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in self.soundDetectionIsRunning = false },
              receiveValue: {
                  self.detectionStates = SpeechState.advanceDetectionStates(self.detectionStates, givenClassificationResult: $0)
              })

      self.detectionStates =
        [SoundIdentifier](config.monitoredSounds)
        .sorted(by: { $0.displayName < $1.displayName })
        .map { ($0, DetectionState(presenceThreshold: 0.5,
                                   absenceThreshold: 0.3,
                                   presenceMeasurementsToStartDetection: 2,
                                   absenceMeasurementsToEndDetection: 30))
        }

      soundDetectionIsRunning = true
      appConfig = config
      SystemAudioClassifier.singleton.startSoundClassification(
        subject: classificationSubject,
        inferenceWindowSize: config.inferenceWindowSize,
        overlapFactor: config.overlapFactor)
  }

  func stopSession() {
        print("stopping session")
        SystemAudioClassifier.singleton.stopSoundClassification()
         detectionCancellable?.cancel()
         soundDetectionIsRunning = false
     }


  static func advanceDetectionStates(_ oldStates: [(SoundIdentifier, DetectionState)],
                                     givenClassificationResult result: SNClassificationResult) -> [(SoundIdentifier, DetectionState)] {
      let confidenceForLabel = { (sound: SoundIdentifier) -> Double in
          let confidence: Double
          let label = sound.labelName
          if let classification = result.classification(forIdentifier: label) {
              confidence = classification.confidence
          } else {
              confidence = 0
          }
          return confidence
      }
      return oldStates.map { (key, value) in
          (key, DetectionState(advancedFrom: value, currentConfidence: confidenceForLabel(key)))
      }
  }
}
