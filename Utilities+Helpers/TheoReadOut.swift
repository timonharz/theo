//
//  File.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import Foundation
import SwiftUI

struct TheoReadOutModifier: ViewModifier {
    // Define any properties you need for your modifier
    var text: String
    @Binding var play: Bool

    let morseCode = MorseCodeModel()
    let hapticEngine = HapticEngine.shared

    @State var currentWordIndex: Int = 0

    var words: [String] {
      return wordsFromString(text)
  }
  var readWords: [String] {
    return elementsBeforeIndex(currentWordIndex, in: words)!
  }
  var readWordsSentence: String {
    return readWords.joined(separator: " ")
  }
  var currentWordToPlay: String {
    return words[currentWordIndex]
  }
  var currentWordMorse: String {
    return morseCode.encodeToMorse(currentWordToPlay)
  }
  var textMorse: String {
    return morseCode.encodeToMorse(text)
  }

    // Implement the body method required by the ViewModifier protocol
    func body(content: Content) -> some View {
        content
        .highlightSubstring(fullString: text, userInput: readWordsSentence, currentIndex: currentWordIndex)
        .onAppear() {
          print("words: \(words)")
          print("read words: \(readWordsSentence)")

          playMorse(index: 0)
        }
        .onChange(of: play) { val in
          if val {
            playMorse(index: 0)
          }
        }
        .onChange(of: readWords) { val in
          print("read words: \(readWordsSentence)")
        }
        .onChange(of: currentWordIndex) { val in
          print("index: \(val)")
        }
    }

  private func playMorse(index: Int) {
      guard play == true else { return }

      if index < words.endIndex {
          currentWordIndex = index
          hapticEngine.playMorseCode(currentWordMorse)
          usleep(100000)

          // Call the function recursively for the next index after a delay
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              self.playMorse(index: index + 1)
          }
      } else {
          print("Reached end index")
        play = false
      }
  }

  //MARK: - Helpers
  private func wordsFromString(_ input: String) -> [String] {
    // Define the character set for splitting words
    let separators = CharacterSet.whitespacesAndNewlines.union(CharacterSet.punctuationCharacters)

    // Split the string into words
    let words = input.components(separatedBy: separators)

    // Filter out empty strings
    let filteredWords = words.filter { !$0.isEmpty }

    return filteredWords
}
  func elementsBeforeIndex(_ index: Int, in array: [String]) -> [String]? {
      guard index >= 0 && index < array.count else {
          print("Index out of bounds")
          return nil
      }

      let elementsBeforeIndex = array[0...index]
      let elements = Array(elementsBeforeIndex)

      return elements
  }
  func elementsBeforeIndexExcluding(_ index: Int, in array: [String]) -> [String]? {
      guard index >= 0 && index < array.count else {
          print("Index out of bounds")
          return nil
      }

      let elementsBeforeIndex = array[0..<index]
      let elements = Array(elementsBeforeIndex)

      return elements
  }

}

extension View {
  func theoReadOut(text: String, play: Binding<Bool>) -> some View {
    self.modifier(TheoReadOutModifier(text: text, play: play))
    }
}
