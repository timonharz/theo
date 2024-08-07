//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI
import AVFAudio

struct MorseTextView: View {
  @State private var indicatorOpacity: CGFloat = 1

  @State private var adoptedFontSize: Font = .title

  @State private var speechSynthesizer: AVSpeechSynthesizer?
  let hapticEngine = HapticEngine.shared
  let speak = Speak()

  var text: String
  var showEditingIndicator: Bool
  var focused: Bool
  var maxCharacter: Int

  var displayText: String {
    return text.replacingOccurrences(of: " ", with: "  ")
     }
  var morseAsText: String {
    return MorseCodeModel().decodeFromMorse(displayText)
  }
  var adjustedXOffset: CGFloat {
    //this moves the indicator to the right if the last character is a space
    text.last! == " " ? 8 : 0
  }
    var body: some View {
      VStack {
        HStack {
          WrappedTextView(text: displayText, maxCharactersPerLine: maxCharacter)
            .font(adoptedFontSize)
            .multilineTextAlignment(.trailing)
            .overlay(
              ZStack {
                if showEditingIndicator && focused {
                  indicatorView().opacity(indicatorOpacity)
                    .offset(x: adjustedXOffset)
                }
              }.offset(x: 4),alignment: .trailing
)
        }.onChange(of: text) { newValue in
          adoptedFontSize(morseCharactersCount: text.count)
        }
      }.onAppear(perform: {
        animateIndicatorOpacity()
      })
      .gesture(MagnificationGesture().onEnded { value in
        if !focused {
          if value > 0  {
            hapticEngine.playMorseCode(displayText)
          } else {
            speak.sayThis(morseAsText)
          }
        }
      })
    }
  @ViewBuilder func indicatorView() -> some View {
    VStack {
      Spacer()
      RoundedRectangle(cornerRadius: 4)
        .fill(Color("accentColor"))
        .frame(width: 3, height: 40)
    }
  }
  private func animateIndicatorOpacity() {
    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
      if indicatorOpacity == 1 {
        withAnimation(.easeOut) {
          indicatorOpacity = 0
        }
      } else {
        withAnimation(.easeIn) {
          indicatorOpacity = 1
        }
      }
    }
  }
  private func speak(text: String) {
    let utterance = AVSpeechUtterance(string: text)
           utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
           utterance.rate = 0.1

           speechSynthesizer = AVSpeechSynthesizer()
           speechSynthesizer?.speak(utterance)
  }
  private func adoptedFontSize(morseCharactersCount: Int) {
      print("adopting font size")
      switch morseCharactersCount {
      case ..<100:
          adoptedFontSize = .largeTitle
      case 100..<300:
          adoptedFontSize = .largeTitle
      case 300..<400:
          adoptedFontSize = .largeTitle
      case 400..<500:
          adoptedFontSize = .title
      case 500..<600:
          adoptedFontSize = .title2
      case 600..<700:
          adoptedFontSize = .title2
      case 700..<800:
          adoptedFontSize = .title3
      case 800..<900:
          adoptedFontSize = .title3
      case 900..<1000:
        adoptedFontSize = .body
      default:
        adoptedFontSize = .title3
      }
  }
}

#Preview {
  MorseTextView(text: "... ---", showEditingIndicator: true, focused: true, maxCharacter: 80)
}
