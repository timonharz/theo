//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import Foundation
import SwiftUI

enum OnboardingState: String, CaseIterable {
  case welcome = "Welcome"
  case whoIsTheoFor = "WhoIsTheoFor"
  case gesturesExplanation = "GesturesExplanation"
  case morseCanvasIntroduction = "MorseCanvasIntroduction"
  case morseDictionaryIntroduction = "MorseDictionaryIntroduction"
}
