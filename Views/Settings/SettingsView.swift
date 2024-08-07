//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 17.02.24.
//

import SwiftUI

struct SettingsView: View {

  @Environment(\.dismiss) var dismiss

  @ObservedObject var appState: AppState
    var body: some View {
      ZStack {
      NavigationStack {
        VStack {
          List {
            Section(header: Text("Settings")) {
              /*
              NavigationLink {
                TactileFeedbackSettingsView().environmentObject(appState)
              } label: {
                HStack {
                  Image(systemName: "iphone.radiowaves.left.and.right").foregroundStyle(Color("accentColor"))
                  Text("Tactile feedback")
                }
              }*/
              NavigationLink {
                VoiceSettingsView()
              } label: {
                HStack {
                  Image(systemName: "speaker.wave.3").foregroundStyle(Color("accentColor"))
                  Text("Voice")
                }
              }
              /*
              NavigationLink {
                Text("test")

              } label: {
                HStack {
                  Image(systemName: "ear").foregroundStyle(Color("accentColor"))
                  Text("I am only deaf")
                }
              }
               */
                NavigationLink {
                  ActiveListeningSettingsView(appState: appState)
                } label: {
                  
                    Image(systemName: "ear").foregroundStyle(Color("accentColor"))
                    Text("Active Listening")

                }
                /*Toggle(isOn: $appState.activeListeningOn, label: {
                  Label("Active Listening", systemImage: "ear")
                })*/
            }
            Section {
              NavigationLink {
                AboutMeView()
              } label: {
                HStack {
                  Image(systemName: "person").foregroundStyle(Color("accentColor"))
                  Text("About")
                }
              }
            }
          }
          .overlay(
            appInfo().padding(.bottom),alignment: .bottom
          )
        }.navigationTitle("You").navigationBarTitleDisplayMode(.large)

        }.toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              dismiss()
            }) {
              Text("Done")
                .font(.headline)
            }
          }
        }
      }
    }
  @ViewBuilder func appInfo() -> some View {
    VStack {
      HStack {
        Image("LogoGraySVG")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: 100)
      }
      HStack {
        Text("version 1.0")
          .foregroundStyle(.gray)
      }
    }
  }
}

#Preview {
    SettingsView(appState: AppState())
}
