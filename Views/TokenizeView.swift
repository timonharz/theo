//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 18.02.24.
//

import SwiftUI

struct TokenizeView: View {
  @Binding var text: String

  @AppStorage("settings_showTokenizeIntroduction") var showedTokenizeIntroduction: Bool = false

  @Environment(\.dismiss) var dismiss

  let textAnalysis = TextAnalysis.shared
  let morseCode = MorseCodeModel()
  let hapticEngine = HapticEngine.shared
  let speak = Speak()

  var tokenizedText: [String] {
    return textAnalysis.tokenizeText(text: text)
  }
  var body: some View {
    NavigationStack {
      VStack {
        if showedTokenizeIntroduction == false {
          tokenizeIntroduction().transition(.opacity)
        } else {
          Divider()
          ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 20) {
              ForEach(tokenizedText, id: \.self) { word in
                HStack {
                  VStack {
                    HStack {
                      Text(word)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                      Spacer()
                    }
                    HStack {
                      MorseTextView(text: morseCode.encodeToMorse(word), showEditingIndicator: false, focused: false, maxCharacter: 100)
                        .foregroundStyle(Color("accentColor"))
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle)
                        .padding(.leading)

                      Spacer()
                    }
                  }
                  Spacer()
                  HStack {
                    Button(action: {
                      hapticEngine.playMorseCode(morseCode.encodeToMorse(word))
                    }) {
                      Image(systemName: "iphone.radiowaves.left.and.right")
                    }
                    Button(action: {
                      speak.sayThis(word)
                    }) {
                      Image(systemName: "speaker.wave.3")
                    }
                  }.padding(.trailing)
                }
                Divider()
              }
            }
          }.frame(maxHeight: .infinity).transition(.opacity)
        }

      }.navigationTitle("Tokenized").navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              dismiss()
            }) {
              Text("Dismiss")
                .font(.headline)
            }
          }
        }
    }
  }
  @ViewBuilder func tokenizeIntroduction() -> some View {
    VStack(alignment: .center) {
      Spacer()
      HStack {
        Image(systemName: "textformat.alt")
          .font(.system(size: 80))
          .foregroundStyle(Color("accentColor"))
          .padding(80)
          .background {
            Circle().fill(Color("accentColor").opacity(0.1))
          }
      }
      HStack {
        Text("What is tokenize?")
          .foregroundStyle(Color("textColor"))
          .font(.largeTitle)
          .fontWeight(.bold)
      }
      HStack {
        Text("Tokenize let's you replay specific parts of the text in morse or speech. It is perfect for the caregiver to explain explicit parts of the given text.")
          .foregroundStyle(.gray)
          .font(.title2)
          .multilineTextAlignment(.center)
      }.padding()
      Spacer()
      HStack {
        Button(action: {
          withAnimation {
            showedTokenizeIntroduction = true
          }
        }) {
          Text("Got it")
            .font(.headline)
            .frame(maxWidth: getRect().width / 2)
        }.tint(Color("accentColor"))
          .controlSize(.large)
          .buttonStyle(.borderedProminent)
      }.padding(.bottom)
    }
  }
}

#Preview {
  TokenizeView(text: .constant("Hiwkjwekrhwerewrewrewrwerewrwe ekwjhr kwejhr kwejhr k"))
}
