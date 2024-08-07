//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI

struct TheoTabsView: View {
  @AppStorage("currentTab") var currentTab: Tabs = .translate

  @StateObject var tVM: TranslateViewModel = TranslateViewModel()
  @StateObject var appState: AppState = AppState()

    var body: some View {
          TabView(selection: $currentTab) {
            TranslateView(viewModel: tVM, appState: appState)
              .tabItem {
                VStack {
                  Image(systemName: "person.2.fill")
                  Text("Chat")
                }
              }.accentColor(Color("accentColor"))
              .tag(Tabs.translate)
            ExploreView(appState: appState)
              .tabItem {
                Image(systemName: "rectangle.grid.2x2")
                Text("Explore")
              }
              .tag(Tabs.explore)
            MorseDictionaryView(appState: appState)
              .tabItem {
                Image(systemName: "character.book.closed")
                Text("Dictionary")
              }.accentColor(Color("accentColor"))
              .tag(Tabs.dictionary)
          }
          .onDeviceShake {
              withAnimation {
                currentTab = .translate
                tVM.focusCanvas = true
              }
          }
          .sheet(isPresented: $appState.showSettings, content: {
            SettingsView(appState: appState)
          })
    }
}

#Preview {
    TheoTabsView()
}
