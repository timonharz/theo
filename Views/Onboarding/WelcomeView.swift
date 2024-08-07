//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import SwiftUI

struct WelcomeView: View {
  @ObservedObject var viewModel: OnboardingViewModel

  @State private var animated: Bool = false
    var body: some View {
      NavigationStack {
        ZStack {
          Color("BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            topBar()
            Spacer()
            HStack {
              Image("WelcomeArtWork2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
            }.scaleEffect(animated ? 1 : 0.4)
            HStack {
              Text("Welcome to theo")
                .foregroundStyle(Color("textColor"))
                .font(.system(size: 50))
                .fontWeight(.bold)
            }.padding(.vertical).scaleEffect(animated ? 1 : 0.4)
            HStack {
              Text("Theo is about experiencing language in a new way, where deafblind individuals can communicate more easily with the outer world through the use of haptics, gestures, and Morse code. Theo's approach fosters inclusive communication by leveraging tactile sensations, movements, and a universally understood coding system, enabling deafblind individuals to actively engage and connect with others.")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .font(.title3)
            }.padding().scaleEffect(animated ? 1 : 0.4)
            Spacer()
            HStack {
              Button(action: {
                viewModel.animate(next: .whoIsTheoFor)
              }) {
                
                Text("Continue")
                  .font(.headline)
                  .foregroundStyle(.white)
                  .frame(maxWidth: getRect().width - 150)
                  .padding(.vertical)
                    .background {
                      RoundedRectangle(cornerRadius: 12).fill(Color("accentColor"))
                    }
              }.buttonStyle(ScaledButtonStyle(strength: .hard))
            }.padding()
          }
        }
      }.onAppear(perform: {
        animateOnAppear()
      })
      .sheet(isPresented: $viewModel.showExplanationSheet, content: {
explanationSheet()
      })
    }
  @ViewBuilder func topBar() -> some View {
    HStack {
      Button(action: {
        viewModel.showExplanationSheet = true
      }) {
        Image(systemName: "questionmark.circle")
          .foregroundStyle(Color("accentColor"))
          .font(.headline)

      }.padding(.leading)
      Spacer()
      HStack {
        Image("LogoHorizontal")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: 100)
      }
      Spacer()
      HStack {
        Button(action: {
          withAnimation(.spring()) {
            viewModel.onboardingDone = true
          }
        }) {
          Text("Skip")
            .foregroundStyle(.gray)
            .font(.headline)
        }
      }.padding(.trailing)
    }
  }
  @ViewBuilder func explanationSheet() -> some View {
    NavigationStack {
      ZStack {
        Color("BG").ignoresSafeArea(.all, edges: .all)
        VStack {
          HStack {
            Spacer()
            Button(action: {
              viewModel.showExplanationSheet = false
            }) {
              Text("Dismiss")
                .foregroundStyle(Color("accentColor"))
                .font(.headline)
            }
          }.padding(.trailing).padding(.top)
          HStack {
            Text("What is deafblindness?")
              .foregroundStyle(Color("textColor"))
              .font(.largeTitle)
              .fontWeight(.bold)
              .padding(.leading)
            Spacer()

          }.padding(.top, getSafeArea().top)
          HStack {
            Text("Deafblindness refers to a combined **loss** of **hearing** and **vision**, resulting in significant **communication** and sensory challenges. Individuals who are deafblind often rely on alternative methods such as **tactile sign language**, **braille**, and **assistive devices** to navigate the world and communicate effectively. **Support services** and interventions tailored to the unique needs of deafblind individuals are crucial for promoting **independence** and **quality of life*.*")
              .foregroundStyle(Color("textColor"))
              .font(.body)
              .multilineTextAlignment(.leading)

              .padding(.leading)
            Spacer()
          }
          Spacer()
        }
      }

    }
  }
  private func animateOnAppear() {
    withAnimation(.easeIn) {
      animated = true
    }
  }
}

#Preview {
    WelcomeView(viewModel: OnboardingViewModel())
}
