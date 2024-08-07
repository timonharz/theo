//
//  File.swift
//  
//
//  Created by Timon Harz on 12.02.24.
//

import Foundation
import AVFoundation
import AVKit
import SwiftUI

final class MorseTonePlayer: NSObject {
  // Dot frequency for Morse code
  private let dotFrequency: Double = 200.0

  // Line frequency for Morse code
  private let lineFrequency: Double = 300.0

  // Duration of a dot in Morse code
  private let dotDuration: Double = 0.5

  // Duration of a line in Morse code
  private let lineDuration: Double = 1.0

  // Audio Unit representing the audio processing graph
  private var auAudioUnit: AUAudioUnit!

  // Flag indicating whether the audiovisual system is active
  private var isAVActive = false

  // Flag indicating whether the audio is running
  private var isAudioRunning = false

  // Sampling rate for audio processing
  private var sampleRate: Double = 44100.0

  // Frequency for generating audio tones
  private var frequency = 750.0

  // Character unit representing the duration of a single Morse code character
  private let characterUnit: CGFloat = 0.2

  // Volume level for audio output
  private var volume = 16383.0

  // Count of tones generated
  private var toneCount: Int32 = 0

  // Phase of the y-axis for audio waveform generation
  private var yPhase = 0.0

  @AppStorage("settings_dotLength") var dotLength: Double = 1
  @AppStorage("settings_lineLength") var lineLength: Double = 2

  /// Function to play Morse code audio based on the input code
  func playMorseCode(code: String) {
      // Check if the audiovisual system is active
      guard isAVActive else { return }

      // Print the Morse code being played
      print("playing morse code for: \(code)")

      // Iterate through each symbol in the Morse code
      for symbol in code {
          // Execute actions based on the Morse code symbol
          switch symbol {
          case ".":
              // Play a dot
              print("playing a dot")
              playDot()
          case "-":
              // Play a line
              print("playing a line")
              playLine()
          case " ":
              // Pause between letters (1 second)
              print("pausing between letters")
              self.play(frequency: 0, duration: 1) {}
          case "|":
              // Pause between words (2 seconds)
              print("pausing between words")
              self.play(frequency: 0, duration: 2) {}
          default:
              break
          }

          // Pause for a short duration between symbols (100 milliseconds)
          usleep(100000)
      }
  }

  /// Play a dot Morse code sound with the specified frequency and duration.
  /// - Parameter completion: An optional closure to be executed upon completion of playing the dot.
  func playDot(completion: (() -> Void)? = nil) {
      self.play(frequency: dotFrequency, duration: dotDuration, completion: completion)
  }

  /// Play a dash Morse code sound with the specified frequency and duration.
  /// - Parameter completion: An optional closure to be executed upon completion of playing the line.
  func playLine(completion: (() -> Void)? = nil) {
      self.play(frequency: lineFrequency, duration: lineDuration, completion: completion)
  }

  /// Play an audio tone with the specified frequency and duration.
  /// - Parameters:
  ///   - frequency: The frequency of the tone to be played.
  ///   - duration: The duration of the tone in seconds.
  ///   - completion: An optional closure to be executed upon completion of playing the tone.
  private func play(frequency: Double, duration: Double, completion: (() -> Void)?) {
      // Check if the audiovisual system is active
      guard self.isAVActive else {
          completion?()
          return
      }

      // Convert the duration to milliseconds and calculate time
      var time = self.characterUnit * duration * 1000

      // Set the frequency, volume, and time for the tone
      self.set(frequency: frequency)
      self.set(volume: 1.0)
      self.set(time: time)

      // Schedule to set the volume to 0 after the specified duration
      DispatchQueue.main.asyncAfter(deadline: .now() + time) {
          self.set(volume: 0.0)
          completion?()
      }
  }

  /// Stop the audio playback and deactivate the audio session.
  func stop() {
      // If audio is currently running, stop the hardware
      if self.isAudioRunning {
          self.auAudioUnit.stopHardware()
          self.isAudioRunning = false
      }

      // If the audiovisual system is active, deactivate the audio session
      if self.isAVActive {
          do {
              try AVAudioSession.sharedInstance().setActive(false)
              self.isAVActive = false
          } catch { }
      }
  }

    func enableSpeaker() {
        guard !self.isAudioRunning else { return }

        if !self.isAVActive {
            do {
                let audioSession = AVAudioSession.sharedInstance()
              try audioSession.setCategory(.soloAmbient)
                var preferredIOBufferDuration = 4.0 * 0.0058

                if audioSession.sampleRate == 48000.0 {
                    self.sampleRate = 48000.0
                    preferredIOBufferDuration = 4.0 * 0.0053
                }

                try audioSession.setPreferredSampleRate(self.sampleRate)
                try audioSession.setPreferredIOBufferDuration(preferredIOBufferDuration)
                try audioSession.setActive(true)
                self.isAVActive = true
            } catch { }
        }

        do {
            let audioComponentDescription = AudioComponentDescription(
                componentType: kAudioUnitType_Output,
                componentSubType: kAudioUnitSubType_RemoteIO,
                componentManufacturer: kAudioUnitManufacturer_Apple,
                componentFlags: 0,
                componentFlagsMask: 0
            )

            if auAudioUnit == nil {
                try auAudioUnit = AUAudioUnit(componentDescription: audioComponentDescription)

                let firstBus = auAudioUnit.inputBusses[0]

                if let audioFormat = AVAudioFormat(
                    commonFormat: .pcmFormatInt16,
                    sampleRate: Double(self.sampleRate),
                    channels: AVAudioChannelCount(2),
                    interleaved: true
                ) {
                    try firstBus.setFormat(audioFormat)
                }

                auAudioUnit.outputProvider = { (_, _, frameCount, _, inputDataList) -> AUAudioUnitStatus in
                    self.fillSpeakerBuffer(inputDataList: inputDataList, frameCount: frameCount)
                    return 0
                }
            }

            self.auAudioUnit.isOutputEnabled = true
            self.toneCount = 0

            try self.auAudioUnit.allocateRenderResources()
            try self.auAudioUnit.startHardware()

            self.isAudioRunning = true
        } catch { }
    }

  /// Set the frequency for audio generation.
  /// - Parameter frequency: The frequency to be set.
  private func set(frequency: Double) {
      self.frequency = frequency
  }

  /// Set the volume level for audio output.
  /// - Parameter volume: The volume level to be set.
  private func set(volume: Double) {
      // Adjust the volume to the appropriate scale
      self.volume = volume * 32766.0
  }

  /// Set the time duration for audio generation.
  /// - Parameter time: The time duration to be set.
  private func set(time: Double) {
      // Calculate the tone count based on the time duration and sample rate
      self.toneCount = Int32(time * self.sampleRate)
  }

  /// Fill the speaker buffer with audio data based on the input parameters.
  /// - Parameters:
  ///   - inputDataList: The list of input audio data.
  ///   - frameCount: The number of frames to be processed.
  private func fillSpeakerBuffer(inputDataList: UnsafeMutablePointer<AudioBufferList>, frameCount: UInt32) {
      // Convert the input data list into a mutable audio buffer list pointer
      let inputDataPtr = UnsafeMutableAudioBufferListPointer(inputDataList)

      // Proceed if there are buffers in the input data list
      if inputDataPtr.count > 0 {
          // Extract the audio buffer from the input data list
          let mBuffers: AudioBuffer = inputDataPtr[0]
          let count = Int(frameCount)

          // Check if the volume and tone count are positive
          if self.volume > 0.0 && self.toneCount > 0 {
              // Adjust the volume if it exceeds the maximum allowed value
              let v = min(self.volume, 32767.0)
              let sz = Int(mBuffers.mDataByteSize)

              // Initialize the sine phase and the phase increment
              var sinPhase = self.yPhase
              let dPhase = 2.0 * Double.pi * self.frequency / self.sampleRate

              // Access the memory of the audio buffer
              if var bptr = UnsafeMutableRawPointer(mBuffers.mData) {
                  // Generate audio samples based on sine wave synthesis
                  for i in 0 ..< count {
                      // Compute the current value of the sine wave
                      let u  = sin(sinPhase)
                      sinPhase += dPhase

                      // Ensure the phase remains within the valid range [0, 2π]
                      if (sinPhase > 2.0 * Double.pi) {
                          sinPhase -= 2.0 * Double.pi
                      }

                      // Convert the sine wave value to a 16-bit signed integer
                      let x = Int16(v * u + 0.5)

                      // Fill the audio buffer with the generated sample values
                      if i < (sz / 2) {
                          bptr.assumingMemoryBound(to: Int16.self).pointee = x
                          bptr += 2
                          bptr.assumingMemoryBound(to: Int16.self).pointee = x
                          bptr += 2
                      }
                  }
              }

              // Update the sine phase and decrement the tone count
              self.yPhase = sinPhase
              self.toneCount -= Int32(frameCount)
          } else {
              // If the volume or tone count is non-positive, fill the buffer with zeros
              memset(mBuffers.mData, 0, Int(mBuffers.mDataByteSize))
          }
      }
  }
}
