//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import Foundation
import AVFoundation
import SwiftUI

class Speak {

  @Published var voices = AVSpeechSynthesisVoice.speechVoices().filter { voice in
    voice.language == "en-US" && voice.quality == .default && voice.gender != .unspecified
  }
    let voiceSynth = AVSpeechSynthesizer()
    @Published var voiceToUse: AVSpeechSynthesisVoice?

  @AppStorage("settings_preferedVoice") var preferedVoice: String = "Samantha"
  @AppStorage("settings_voiceRate") var voiceRate: Double = 0.5

  init() {
          for voice in voices {
              if voice.name == preferedVoice && voice.language == "en-US" {
                  voiceToUse = voice
              }
          }

          setupAudioSession()
      }

      private func setupAudioSession() {
          do {
              try AVAudioSession.sharedInstance().setCategory(.ambient)
              try AVAudioSession.sharedInstance().setActive(true)
              NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)
          } catch {
              print("Failed to set up audio session: \(error.localizedDescription)")
          }
      }

      @objc private func handleInterruption(_ notification: Notification) {
          guard let userInfo = notification.userInfo,
                let interruptionTypeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeValue) else {
              return
          }

          switch interruptionType {
          case .began:
              // Handle interruption began
              print("Audio interruption began")
              // Pause speech synthesis if needed
              if voiceSynth.isSpeaking {
                  voiceSynth.pauseSpeaking(at: .word)
              }
          case .ended:
              // Interruption ended
              print("Audio interruption ended")
              // Resume speech synthesis if it was paused
              voiceSynth.continueSpeaking()
          }
      }

      func sayThis(_ phrase: String) {
          guard !phrase.isEmpty else { return }
          let utterance = AVSpeechUtterance(string: phrase)
          utterance.voice = voiceToUse
          utterance.rate = Float(voiceRate)

          voiceSynth.speak(utterance)
      }

      func setVoice(_ voiceName: String) {
          for voice in voices {
              if voice.name == voiceName && voice.language == "en-US" {
                  voiceToUse = voice
                  return
              }
          }
          // If the specified voice is not found, set to default
          voiceToUse = AVSpeechSynthesisVoice(language: "en-US")
          preferedVoice = "Samantha"
      }
}
