//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 12.02.24.
//

import SwiftUI

struct ExploreView: View {
  @ObservedObject var appState: AppState

  let hapticEngine = HapticEngine.shared

  var showConfigureActiveListeningWidget: Bool {
    !appState.activeListeningOn && presentActiveListeningWidget
  }
  @State private var presentActiveListeningWidget: Bool = true

    var body: some View {
      NavigationStack {
        ZStack {
          Color("BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            ScrollViewReader { reader in
              ScrollView(.vertical, showsIndicators: false) {
                VStack {
                  topSection.background {
                    meshGradientHeader()
                  }
                  section(title: "Improve your skills", subTitle: "Practices", content: {
                    VStack {
                      PracticeReelView()
                    }
                  }).padding(.vertical).frame(maxWidth: .infinity)
                  section(title: "Articles", subTitle: "", content: {
                    ArticlesReelView(articles: allArticles).frame(maxHeight: 200)
                  }).padding(.vertical).frame(maxWidth: .infinity)
                  section(title: "Gestures", subTitle: "Recap", content: {
                    GestureReelView()
                  })
                  section(title: "Todos", subTitle: "", content: {
                    HStack {
                      TodoCellView(appState: appState)
                        .frame(maxWidth: getRect().width - 100)
                        .padding()
                      Spacer()
                    }
                  })
                  if showConfigureActiveListeningWidget {
                    section(title: "", subTitle: "") {
                      HStack {
                        Spacer()
                        ConfigureActiveListeningWidgetView(appState: appState, show: $presentActiveListeningWidget).frame(maxWidth: getRect().width - 100).animation(.easeOut)
                        Spacer()
                      }
                    }
                  }

                  Spacer()
                }
              }.frame(maxHeight: .infinity)
            }
          }
        }
      }
    }
  var topSection: some View {
    HStack {
      Text("Explore")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding(.leading)
      Spacer()
    }.padding(.top, getSafeArea().top * 2)
      .overlay(
        Button(action: {
          appState.showSettings = true
        }) {
          Image(systemName: "gearshape")
            .font(.title3)
            .fontWeight(.semibold)
            .padding(10)

            .background {
              Circle().fill(.white)
            }.padding(.trailing)
        }, alignment: .topTrailing
      )
  }
  @ViewBuilder func meshGradientHeader() -> some View {
    HStack {
      MeshGradient(colors: [Color("lightPurple"), Color("lightGreen"), Color("lightPink"), Color("lightYellow"), Color("lightBlue"), Color("accentColor")], blurred: 80, animated: true, speed: 20).opacity(0.8)
        .frame(width: getRect().width)
    }
  }
  @ViewBuilder func section(title: String, subTitle: String?, @ViewBuilder content: () -> some View) -> some View {
    VStack(alignment: .leading) {
      HStack {
        Text(title)
          .foregroundStyle(Color("textColor"))
          .font(.title)
          .fontWeight(.bold)
          .padding(.leading)
        Spacer()
      }
      content().padding()
    }
  }
}

#Preview {
  ExploreView(appState: AppState())
}
