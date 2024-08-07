//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import Foundation
import SwiftUI

enum MorseCanvasIntroductionWalkthroughState: String, CaseIterable {
  case addDot = "AddDot"
  case addLine = "AddLine"
  case delete = "Delete"
  case result = "Result"
  case space = "Space"
  case tapAndHold = "TapAndHold"
  case speak = "Speak"
  case reset = "Reset"
  case feel = "Feel"
}
