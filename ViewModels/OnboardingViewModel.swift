//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import Foundation
import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {
  @Published var currentState: OnboardingState = .welcome


  @Published var showExplanationSheet: Bool = false
  @AppStorage("onboardingDone") var onboardingDone: Bool = false

  //MARK: - Morse Canvas Introduction
  @Published var morseCanvasIntroductionCode: String = ""
  @Published var morseWalkthroughState: MorseCanvasIntroductionWalkthroughState = .addDot
  @Published var showResult: Bool = false
  @Published var result: String = ""
  @Published var continueWalkthough: Bool = false
  @Published var detailedWalkthroughEnded: Bool = false

  private let morseCode = MorseCodeModel()

  var morseCanvasCodeText: String {
    return morseCode.decodeFromMorse(morseCanvasIntroductionCode)
  }

  func animate(next: OnboardingState) {
    withAnimation(.spring()) {
      currentState = next
    }
  }
}
