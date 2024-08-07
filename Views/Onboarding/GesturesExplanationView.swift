//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import SwiftUI

struct GesturesExplanationView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  var body: some View {
    NavigationStack {
      ZStack {
        Color("BG").ignoresSafeArea(.all, edges: .all)
        VStack {
          HStack {
            Image("LogoHorizontal")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: 100)
          }
          HStack {
            Text("You will now learn how to communicate and navigate with theo.")
              .font(.largeTitle)
              .fontWeight(.semibold)
              .foregroundStyle(Color("textColor"))
              .frame(maxWidth: 350)
              .padding(.leading)
            Spacer()
          }.padding()
          HStack {
            Text("You navigate with \(Text("**Gestures**").foregroundColor(Color("accentColor"))).")
              .font(.largeTitle)
              .fontWeight(.semibold)
              .foregroundStyle(Color("textColor"))
              .padding(.leading)
            Spacer()
          }.padding()
          Spacer()
          gestureIllustration
          Spacer()
          HStack {
            Button(action: {
              viewModel.animate(next: .morseCanvasIntroduction)
            }) {
              Text("Next")
                .foregroundStyle(.white)
                .font(.headline)
                .frame(maxWidth: getRect().width - 150)
                .padding(.vertical)
                .background {
                  RoundedRectangle(cornerRadius: 12)
                    .fill(.black)
                }
            }
          }.padding()
        }
      }
    }
  }
  var gestureIllustration: some View {
    ZStack {
      Image(systemName: "rectangle.and.hand.point.up.left.filled")
        .resizable()
        .foregroundStyle(Color("textColor"))
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: 300)

    }
  }
}

#Preview {
  GesturesExplanationView(viewModel: OnboardingViewModel())
}
