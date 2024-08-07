//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 18.02.24.
//

import SwiftUI

struct WhoIsTheoForView: View {
  @ObservedObject var viewModel: OnboardingViewModel
    var body: some View {
      NavigationStack {
        ZStack {
          Color("BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            HStack {
              Spacer()
              Image("LogoHorizontal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100)
              Spacer()
            }
            VStack(alignment: .leading) {
              HStack {
                Text("Theo was designed for \(Text("deafblind individuals").foregroundColor(Color("accentColor"))).")
                  .font(.largeTitle)
                  .fontWeight(.semibold)
                Spacer()
              }.padding(.leading)
              HStack {
                Text("It translates text into morse code and then into tactile feedback. Remove your headphones, turn up the volume and place one hand at the back of the device.")
                  .font(.largeTitle)
                  .fontWeight(.semibold)
                  .padding(.leading)
                Spacer()
              }
            }.padding()
            Spacer()
            HStack {
              Image("ShakeGesture")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 500)
            }
            Spacer()
            HStack {
              Button(action: {
                viewModel.animate(next: .gesturesExplanation)
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
}

#Preview {
  WhoIsTheoForView(viewModel: OnboardingViewModel())
}
