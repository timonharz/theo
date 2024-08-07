//
//  File.swift
//  
//
//  Created by Timon Harz on 12.02.24.
//

import Foundation

enum ConversationSpeaker: String, CaseIterable {
  case you = "You"
  case they = "They"

  var description: String {
    switch self {
    case .you:
      return "You"
    case .they:
      return "They"
    }
  }
}
