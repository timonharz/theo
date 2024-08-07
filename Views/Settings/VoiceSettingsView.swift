//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 17.02.24.
//

import SwiftUI

struct VoiceSettingsView: View {
  @StateObject var appState: AppState = AppState()
  @AppStorage("settings_preferedVoice") var preferedVoice: String = "Samantha"
  @AppStorage("settings_voiceRate") var voiceRate: Double = 0.5

  var displayVoiceRate: String {
    return String(format: "%.1f", voiceRate)
  }

  @State private var changingVoice: Bool = false

  let speak = Speak()
    var body: some View {
      NavigationStack {
        VStack {
          List {
            Section {
              HStack {
                Text(speak.preferedVoice)
                  .font(.title3)
                  .fontWeight(.bold)
                Spacer()

                  .foregroundStyle(.gray)
              }
              HStack {
                Text("Speed:")
                Spacer()
                Stepper {
                  voiceRate += 0.1
                } onDecrement: {
                  guard voiceRate > 0.1 else { return }
                  voiceRate -= 0.1
                } label: {
                  Text(displayVoiceRate)
                }

              }
            }
            Section(header: Text("Voices"), footer: Text("Choose a voice that resonates with your preferences and best represents you as an individual.")) {
              ForEach(speak.voices, id: \.self) { voice in
                Button(action: {
                  changingVoice = true
                  preferedVoice = voice.name
                  speak.setVoice(voice.name)
                  speak.sayThis("Hi I am \(voice.name)")
                  changingVoice = false
                }) {
                  HStack {
                    Text(voice.name).foregroundStyle(Color("textColor"))
                    Spacer()
                    
                  }
                }
              }
            }
          }
        }.navigationTitle("Voice").navigationBarTitleDisplayMode(.large)
      }
    }
}

#Preview {
    VoiceSettingsView()
}
