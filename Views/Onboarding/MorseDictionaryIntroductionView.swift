//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI

struct MorseDictionaryIntroductionView: View {
  @ObservedObject var viewModel: OnboardingViewModel
    var body: some View {
      NavigationStack {
        ZStack {
          Color("BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            HStack {
              topBar()
            }.padding(.top)
            
            introductionText.frame(maxWidth: .infinity)
            Spacer()
            Spacer()
            HStack {
              Button(action: {
                withAnimation(.spring()) {
                  viewModel.onboardingDone = true
                }
              }) {
                Text("Finish onboarding")
                  .foregroundStyle(.white)
                  .font(.headline)
                  .frame(maxWidth: getRect().width - 150)
                  .padding(.vertical)
                  .background {
                    RoundedRectangle(cornerRadius: 12)
                      .fill(.black)
                  }
              }
            }.padding(.bottom)
          }
        }
      }
    }
  @ViewBuilder func topBar() -> some View {
    HStack {
      Spacer()
      HStack {
        Image("LogoHorizontal")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: 100)
      }
      Spacer()
    }
  }
  var introductionText: some View {
    VStack {
      VStack(spacing: 0) {
        HStack {
          Text("Remeber you can always look up the morse code for any symbol in the \(Text("\(Image(systemName: "character.book.closed"))dictionary tab").foregroundColor(Color("accentColor"))) and feel it.")
            .foregroundStyle(Color("textColor"))
          Spacer()
        }.padding(.leading)

        Spacer()
      }.font(.largeTitle).fontWeight(.semibold).foregroundStyle(.white)
    }
  }
}

#Preview {
  MorseDictionaryIntroductionView(viewModel: OnboardingViewModel())
}
