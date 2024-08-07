//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 24.02.24.
//

import SwiftUI

struct ActiveListeningIndicator: View {
  @ObservedObject var appState: AppState

  var indicatorText: String {
    return appState.activeListeningOn ? "Active" : "Off"
  }
  var popUpText: String {
    return appState.activeListeningOn ? "Active Listening is on" : "Active Listening is turned off"
  }
  var popUpDescriptionText: String {
    return appState.activeListeningOn ? "Go to Settings > Active Listening to turn it off" : "Go to Settings > Active Listening to turn it on"
  }

  var activeListeningOn: Bool

  @State private var showPopup: Bool = false
  var body: some View {
    Button(action: {
      showPopup.toggle()
    }) {
      HStack {
        Circle()
          .fill(activeListeningOn ? Color("accentColor") : Color(.systemGray4))
          .frame(width: 15, height: 15)
        Text(indicatorText)
          .foregroundStyle(Color("textColor"))
      }.padding(10).background(Color("widgetBG")).clipShape(RoundedRectangle(cornerRadius: 12)).overlay(
        RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 0.5)
      )
    }.buttonStyle(ScaledButtonStyle(strength: .medium)).popover(isPresented: $showPopup, content: {
      popUpContent().padding()
    })
  }
  @ViewBuilder func popUpContent() -> some View {
    VStack(alignment: .leading) {
      HStack {
        Circle()
          .fill(activeListeningOn ? Color("accentColor") : Color(.systemGray4))
          .frame(width: 20, height: 20)
        Text(popUpText)
          .font(.title3)
          .fontWeight(.semibold)
      }
      HStack {
        Text(popUpDescriptionText)
          .foregroundStyle(.gray)
          
      }
    }
  }
}

#Preview {
  ActiveListeningIndicator(appState: AppState(), activeListeningOn: true)
}
