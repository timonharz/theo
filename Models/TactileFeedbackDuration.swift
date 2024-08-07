//
//  File.swift
//  
//
//  Created by Timon Harz on 18.02.24.
//

import Foundation
import SwiftUI
import Combine

enum TactileFeedbackDotDuration: Float, CaseIterable {
  case veryShort = 0.2
  case short = 0.5
  case mid = 1
  case long = 2
  case veryLong = 2.5

  var description: String {
    switch self {
    case .veryShort:
      return "Very Short"
    case .short:
      return "Short"
    case .mid:
      return "Regular"
    case .long:
      return "Long"
    case .veryLong:
      return "Vely long"
    }
  }
}

enum TactileFeedbackLineDuration: Float, CaseIterable {
  case veryShort = 0.5
  case short = 1
  case mid = 2
  case long = 3
  case veryLong = 4
  
  var description: String {
    switch self {
    case .veryShort:
      return "Very Short"
    case .short:
      return "Short"
    case .mid:
      return "Regular"
    case .long:
      return "Long"
    case .veryLong:
      return "Vely long"
    }
  }
}
