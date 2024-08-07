//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import Foundation
import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
  var strength: ScaledButtonAnimationStrength
  private var animationValue: CGFloat {
    switch strength {
    case .soft:
      return 0.94
    case .medium:
      return 0.8
    case .hard:
      return 0.6
    case .extraHard:
      return 0.4
    }
  }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? animationValue : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
enum ScaledButtonAnimationStrength {
  case soft
  case medium
  case hard
  case extraHard
}

