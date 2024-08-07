//
//  File.swift
//  
//
//  Created by Timon Harz on 09.02.24.
//

import Foundation
import CoreHaptics
import AVFoundation
import SwiftUI


class HapticEngine {
    static let shared = HapticEngine()
    private let morseTonePlayer: MorseTonePlayer = .init()

    private var engine: CHHapticEngine?
    private var audioPlayer: AVAudioPlayer?

    @AppStorage("settings_dotLength") var dotLength: Double = 1
    @AppStorage("settings_lineLength") var lineLength: Double = 2

    private init() {
        setupHapticEngine()
    }

    private func setupHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support haptics")
            return
        }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
            setupHandlers()
        } catch let error {
            print("Error starting haptic engine: \(error.localizedDescription)")
        }
    }

    private func setupHandlers() {
        // Reset Handler
        engine?.resetHandler = {
            print("Reset Handler: Restarting the engine.")
            do {
                try self.engine?.start()
                // Re-register custom resources and recreate players here
            } catch {
                fatalError("Failed to restart the engine: \(error)")
            }
        }

        // Stopped Handler
        engine?.stoppedHandler = { reason in
            print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt: print("Audio session interrupt")
            case .applicationSuspended: print("Application suspended")
            case .idleTimeout: print("Idle timeout")
            case .systemError: print("System error")
            @unknown default:
                print("Unknown error")
            }
            // Handle each cause accordingly
        }
    }

  func playMorseCode(_ code: String) {


      if !CHHapticEngine.capabilitiesForHardware().supportsHaptics {
        print("play audio")
        morseTonePlayer.enableSpeaker()
        morseTonePlayer.playMorseCode(code: code)
        morseTonePlayer.stop()
          return
      } else {
        print("playing haptics because it is supported")
      }

    guard let engine = engine else {
      print("haptic engine not availabe")
      return
    }
      var events = [CHHapticEvent]()

      for char in code {
          switch char {
          case ".":
              events.append(createHapticEvent(intensity: 0.8, sharpness: 0.8, duration: dotLength))
              events.append(createHapticEvent(intensity: 0, sharpness: 0, duration: 0.5))
          case "-":
              events.append(createHapticEvent(intensity: 1.0, sharpness: 1.0, duration: lineLength))
              events.append(createHapticEvent(intensity: 0, sharpness: 0, duration: 0.5))
          case " ":
              // Add a pause between characters
              events.append(createHapticEvent(intensity: 0, sharpness: 0, duration: 1))
          default:
              break
          }
      }

      do {
          let pattern = try CHHapticPattern(events: events, parameters: [])
          let player = try engine.makePlayer(with: pattern)
          try player.start(atTime: CHHapticTimeImmediate)
      } catch let error {
          print("Error playing haptic pattern: \(error.localizedDescription)")
      }
  }
  private func playAudio(filename: String) {
          guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
              print("File \(filename).wav not found")
              return
          }

          do {
            // Create an AVAudioPlayer instance with the sound file URL
            audioPlayer = try AVAudioPlayer(contentsOf: url)

            // Prepare the audio player for playback
            audioPlayer?.prepareToPlay()

                            // Play the audio file
            audioPlayer?.play()
          } catch let error {
              print("Error playing audio: \(error.localizedDescription)")
          }
      }

    private func createHapticEvent(intensity: Float, sharpness: Float, duration: TimeInterval) -> CHHapticEvent {
        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensityParam, sharpnessParam], relativeTime: 0, duration: duration)
        return event
    }
}
