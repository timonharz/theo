//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import SwiftUI

struct OnboardingView: View {
  @StateObject var viewModel: OnboardingViewModel = OnboardingViewModel()
    var body: some View {
      NavigationStack {
        ZStack {
          Color(viewModel.currentState == .welcome ? "accentBG" : "BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            switch viewModel.currentState {
            case .welcome:
              WelcomeView(viewModel: viewModel).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading).combined(with: .opacity)))
            case .whoIsTheoFor:
              WhoIsTheoForView(viewModel: viewModel).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading).combined(with: .opacity)))
            case .gesturesExplanation:
              GesturesExplanationView(viewModel: viewModel).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading).combined(with: .opacity)))
            case .morseCanvasIntroduction:
              MorseCanvasIntroductionView(viewModel: viewModel).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading).combined(with: .opacity)))
            case .morseDictionaryIntroduction:
              MorseDictionaryIntroductionView(viewModel: viewModel).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading).combined(with: .opacity)))
            }
          }
        }
      }
    }
}

#Preview {
    OnboardingView()
}
