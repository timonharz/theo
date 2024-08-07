//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI
import AVFoundation

struct MorseCanvasView: View {
  @Binding var morse: String
  @Binding var interacting: Bool
  @Binding var focused: Bool
  var reactToPinch: Bool
  var showMorse: Bool
  var bg: Color
  @ObservedObject var speechRecognizer: SpeechState
  var config: SpeechDetection
  @State private var speechSynthesizer: AVSpeechSynthesizer?

  @State private var adoptedFontSize: Font = .system(size: 60)

  let hapticEngine = HapticEngine.shared
  let speak = Speak()

  var morseAsText: String {
    return MorseCodeModel().decodeFromMorse(morse)
  }

  var canvasIsEmpty: Bool {
    return morse.isEmpty
  }
    var body: some View {
      ZStack {
        bg.ignoresSafeArea(.all, edges: .all)
        VStack {
          VStack {
            
            if canvasIsEmpty {
              HStack {
                Text("\(Image(systemName: "hand.tap"))Tap here to start morse editing")
                  .foregroundStyle(.gray)
                  .font(.title2)

              }.frame(height: 100)
            }
            else {
              VStack {
                if showMorse {
                  //MorseCodeView(code: morse, height: 5, width: 10, color: .black).frame(maxHeight: 200)
                  VStack {
                    MorseTextView(text: morse, showEditingIndicator: showMorse, focused: focused, maxCharacter: 150)
                        .foregroundStyle(Color("accentColor"))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.trailing)

                  }.frame(maxHeight: .infinity)
                }

              }.padding()
            }
          }
        }.frame(width: getRect().width - 100).contentShape(RoundedRectangle(cornerRadius: 0))

      }.contentShape(Rectangle())
        .gesture(
          TapGesture(count: 1).onEnded {
            interacting = true
           
           // withAnimation(.easeIn) {
              morse.append(".")

         //   }
              hapticEngine.playMorseCode(".")

            interacting = false
          }
        )
        .highPriorityGesture(
          TapGesture(count: 2).onEnded {
            interacting = true
            print("running double tap gesture")

            guard morse.last != nil else { return }
            withAnimation(.easeOut) {
              morse.append(" ")
            }
            interacting = false
          }
        )
      .simultaneousGesture(
        DragGesture(minimumDistance: 20, coordinateSpace: .local).onEnded { value in
          interacting = true
          let horizontalAmount = value.translation.width
          let verticalAmount = value.translation.height
          if abs(horizontalAmount) > abs(verticalAmount) {
              print(horizontalAmount < 0 ? "left swipe" : "right swipe")
            if horizontalAmount > 0 {

             // withAnimation(.easeInOut(duration: 0.1)) {

                morse.append("-")

            //  }
              hapticEngine.playMorseCode("-")

            }
            if horizontalAmount < 0 {
              guard morse.last != nil else { return }
              withAnimation(.easeOut(duration: 0.1)) {
                morse.removeLast()
              }
            }
          } else {
              print(verticalAmount < 0 ? "up swipe" : "down swipe")
          }
          interacting = false
        }
      )
      .simultaneousGesture(
        LongPressGesture(minimumDuration: 0.5).onEnded({ value in
          interacting = true
          guard morse.last != "|" else { return }
          morse.append(" ")
          morse.append("|")
        //  morse.append(" ")
          hapticEngine.playMorseCode("|")
          interacting = false
        })
      )
      .simultaneousGesture(
        MagnificationGesture().onEnded { value in
          if reactToPinch {
            interacting = true
            print("zooming value: \(value)")
            if value > 1 {
              print("zooomed in on morse canvas")
              hapticEngine.playMorseCode(morse)
            } else if value < 1.0 {
              speak.sayThis(morseAsText)
            }
            interacting = false
          }
        }
      )
    }
  private func speak(text: String) {
    let utterance = AVSpeechUtterance(string: text)
           utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
           utterance.rate = 0.1

           speechSynthesizer = AVSpeechSynthesizer()
           speechSynthesizer?.speak(utterance)
  }

}
