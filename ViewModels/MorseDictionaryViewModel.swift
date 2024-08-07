//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI
import Foundation
import Combine

final class MorseDictionaryViewModel: ObservableObject {
  @Published var searchText: String = ""

  @Published var showSettings: Bool = false

  let hapticEngine = HapticEngine.shared
  let morseCode = MorseCodeModel()

  var filteredSymbols: [MorseSymbol] {
          guard !searchText.isEmpty else {
              return morseCode.morseSymbols // Return all symbols if searchText is empty
          }

          // Filter the morseSymbols array based on the searchText
          let filtered = morseCode.morseSymbols.filter { symbol in
              String(symbol.symbol).lowercased().contains(searchText.lowercased())
          }

          return filtered
      }

  var sentenceMorseCode: String {
    if searchText.count > 1 {
      return morseCode.encodeToMorse(searchText)
    } else {
      return ""
    }
  }
}
