//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI

struct MorseDictionaryView: View {
  @StateObject var viewModel = MorseDictionaryViewModel()
  @ObservedObject var appState: AppState


  var gridItems: [GridItem] = [GridItem(.flexible(minimum: 100, maximum: 300)), GridItem(.flexible(minimum: 100, maximum: 300)),GridItem(.flexible(minimum: 100, maximum: 300)), GridItem(.flexible(minimum: 100, maximum: 300))]
    var body: some View {
      NavigationStack {
        ZStack {
          Color("BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            ScrollView(.vertical, showsIndicators: true) {
              LazyVGrid(columns: gridItems) {
                ForEach(viewModel.filteredSymbols, id: \.self) { item in
                  Button(action: {
                    viewModel.hapticEngine.playMorseCode(item.code)
                  }) {
                    symbolItem(symbol: String(item.symbol), morse: item.code)
                  }.buttonStyle(ScaledButtonStyle(strength: .hard))
                }
              }
              if viewModel.searchText.count > 1 {
                  sentenceItem(text: viewModel.searchText, morse: viewModel.sentenceMorseCode).padding()
              }
            }.padding()
          }.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer)
        }.navigationTitle("Morse Dictionary").navigationBarTitleDisplayMode(.large)
          .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              Button(action: {
                appState.showSettings = true
              }) {
                Image(systemName: "gearshape")
                  .font(.headline)
                  .fontWeight(.semibold)
                  .padding(5)
                  .background {
                    Circle().fill(.white)
                  }.padding(.trailing)
              }
            }
          }
      }
    }
  @ViewBuilder func symbolItem(symbol: String, morse: String) -> some View {
    VStack {
      Text(symbol)
        .foregroundStyle(.black)
        .font(.system(size: 60))
        .fontWeight(.bold)
      HStack {
        MorseCodeView(code: morse, height: 10, width: 20, color: .black)
      }
    }.padding().frame(maxWidth: 250).background {
      RoundedRectangle(cornerRadius: 25).fill(.white)
    }
  }
  func sentenceItem(text: String, morse: String) -> some View {
    VStack {
      Text(text)
        .foregroundStyle(.black)
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding(.top)
      HStack {
        Text(morse).foregroundStyle(.black)
          .font(.largeTitle)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .frame(maxWidth: 300)
      }
    }.padding().background {
      RoundedRectangle(cornerRadius: 25).fill(.white)
    }.overlay(
      Button(action: {
        copyToClipboard(text: morse)
      }) {
        Image(systemName: "doc.on.doc")
          .foregroundStyle(.gray)

      }.padding(.leading).padding(.top), alignment: .topLeading
    )
  }
  func copyToClipboard(text: String) {
         let pasteboard = UIPasteboard.general
         pasteboard.string = text
     }
}

#Preview {
  MorseDictionaryView(appState: AppState())
}
