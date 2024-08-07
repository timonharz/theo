//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 24.02.24.
//

import SwiftUI

struct ConfigureActiveListeningWidgetView: View {
  @ObservedObject var appState: AppState
  @Binding var show: Bool
    var body: some View {
      VStack {
        HStack {
          Text("Beta")
            .foregroundStyle(.white)
            .padding(6)
            .background {
              Capsule()
                .fill(Color("accentColor"))
            }.padding(.leading).padding(.top)
          Spacer()
          Button(action: {
            show = false
          }) {
            Image(systemName: "xmark")
              .font(.title3)
              .foregroundStyle(.gray)
          }.padding(.trailing).padding(.top)
        }
        Spacer()
        VStack {
          activeListeningLogo
          description.frame(maxWidth: .infinity)
        }.padding()
        Spacer()
        enableButton.padding()
      }.background {
        RoundedRectangle(cornerRadius: 20).fill(.white)
      }
    }
  var activeListeningLogo: some View {
    HStack {
      Image(systemName: "ear")
        .font(.system(size: 80))
        .foregroundStyle(Color("accentColor"))
        .padding(40)
        .background {
          Circle().fill(Color(.systemGray6))
        }
    }
  }
  var description: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Enable Active Listening")
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding(.leading)
        Spacer()
      }
      HStack {
        Text("Active Listening will automatically start transcribing speech around you if you enable it. It is designed for the needs of deafblind individuals.")
          .font(.title3)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.leading)
          Spacer()
      }
    }
  }
  var enableButton: some View {
    HStack {
      Button(action: {
        withAnimation {
          appState.activeListeningOn = true
          show = false
        }
      }) {
        Text("Enable")
          .font(.headline)
          .frame(maxWidth: getRect().width / 1.3)
      }.tint(Color("accentColor"))
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
    }
  }
}

#Preview {
  ZStack {
    Color("BG").ignoresSafeArea(.all, edges: .all)
    ConfigureActiveListeningWidgetView(appState: AppState(), show: .constant(true)).frame(maxWidth: UIScreen.main.bounds.width - 200, maxHeight: 400)
  }
}
