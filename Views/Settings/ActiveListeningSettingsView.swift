//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 24.02.24.
//

import SwiftUI

struct ActiveListeningSettingsView: View {

  @ObservedObject var appState: AppState
 
  var body: some View {
      NavigationStack {
        ZStack {
          /*Color.clear.overlay(MeshGradient(colors: [Color("lightBlue")], size: CGSize(width: getRect().width, height: 300), blurred: 100, animated: true, speed: 30), alignment: .top)
              .ignoresSafeArea()*/
          VStack {

            List {
              Section(footer: Text("Active Listening will be interrupted when you focus a textfield or start entering morse code.")) {
                Toggle("Active Listening", isOn: $appState.activeListeningOn)
              }
            }//.scrollContentBackground(.hidden)

          }.navigationTitle("Active Listening")
      }
      }
  }
}

#Preview {
  ActiveListeningSettingsView(appState: AppState())
}
