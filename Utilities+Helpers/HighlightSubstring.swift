//
//  File.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import Foundation
import SwiftUI

struct HighlightSubstring: ViewModifier {
    let fullString: String
    let userInput: String
    var currentIndex: Int

    func body(content: Content) -> some View {
        let attributedString = createAttributedString(fullString: fullString, userInput: userInput)

        return content
        .overlay(Text(AttributedString(attributedString)), alignment: .center)
    }

    private func createAttributedString(fullString: String, userInput: String) -> NSAttributedString {
      if currentIndex != 0 {
        let attributedString = NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

        let fullStringLowercased = fullString.lowercased()
        let userInputLowercased = userInput.lowercased()

        var inputIndex = 0
        var matchIndex = 0

        while inputIndex < userInputLowercased.count && matchIndex < fullStringLowercased.count {
          let inputChar = userInputLowercased[userInputLowercased.index(userInputLowercased.startIndex, offsetBy: inputIndex)]
          let fullChar = fullStringLowercased[fullStringLowercased.index(fullStringLowercased.startIndex, offsetBy: matchIndex)]

          if inputChar == fullChar {
            let range = NSRange(location: matchIndex, length: 1)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "accentColor"), range: range)
            inputIndex += 1
          }

          matchIndex += 1
        }
        return attributedString
      }
      return NSAttributedString(string: fullString)
    }
}

extension View {
  func highlightSubstring(fullString: String, userInput: String, currentIndex: Int) -> some View {
    self.modifier(HighlightSubstring(fullString: fullString, userInput: userInput, currentIndex: currentIndex))
    }
}
