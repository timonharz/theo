//
//  File.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import Foundation
import SwiftUI
import Combine
import Vision
import CoreML

public class PracticeViewModel: ObservableObject {
  let morseCode = MorseCodeModel()

  //MARK: - Writing a Word with morse
  @Published var writingWordsIndex: Int = 0
  @Published var randomWordsToWrite: [String] = ["Hi"]
  @Published var interactingWithMorseCanvas: Bool = false
  @Published var hideMorse: Bool = false

   var writtenWord: String {
     return morseCode.decodeFromMorse(writtenMorse)
   }
  
  @Published var writtenMorse: String = ""

  var practiceDone: Bool {
    return writingWordsIndex > 2
  }
  var showNextButton: Bool {
    return writtenWord == currentRandomWordToWrite.uppercased() && practiceDone == false
  }

  var currentRandomWordToWrite: String {
    return randomWordsToWrite[writingWordsIndex]
  }
  var currentWordToWriteMorse: String {
    return morseCode.encodeToMorse(currentRandomWordToWrite)
  }

  var allRandomWordsToWrite = ["Hi", "Hello", "WWDC", "Theo", "Swift"]

  func getRandomWordsToWrite() {
      var tempRandomWords: [String] = []

      for _ in 0..<4 {
          if let randomWordIndex = allRandomWordsToWrite.indices.randomElement() {
              let randomWord = allRandomWordsToWrite[randomWordIndex]
              tempRandomWords.append(randomWord)
              allRandomWordsToWrite.remove(at: randomWordIndex)
          }
      }
      randomWordsToWrite = tempRandomWords
  }
  //helper
  var displayWord: AttributedString {
    return AttributedString(createAttributedString(fullString: randomWordsToWrite[writingWordsIndex], userInput: writtenWord))
  }
  func createAttributedString(fullString: String, userInput: String) -> NSAttributedString {
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
              attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
              inputIndex += 1
          }

          matchIndex += 1
      }

      return attributedString
  }
  //MARK: - Deleting a Word
  @Published var showDeletingWordsInstructions: Bool = false
  @Published var currentDeletingWordsIndex: Int = 0
  @Published var currentDeletingSentencesIndex: Int = 0
  @Published var randomWords: [String] = ["THEO"]
      @Published var randomSentences: [String] = ["How are you?"]
      @Published var confettiCount: Int = 1

      var nowDeletingSentences: Bool {
          return currentDeletingWordsIndex > 1
      }

      var currentWord: String {
          return randomWords[currentDeletingWordsIndex]
      }

      var currentWordMorse: String {
          return morseCode.encodeToMorse(currentWord)
      }

      var currentSentence: String {
          return randomSentences[currentDeletingSentencesIndex]
      }

      var currentSentenceMorse: String {
          return morseCode.encodeToMorse(currentSentence)
      }

      var deletingPracticeDone: Bool {
          return currentDeletingSentencesIndex > 0
      }

      var deletingWordsInstructions: String {
          if !nowDeletingSentences {
              return "Try deleting the following word"
          } else {
              return "Try deleting the following sentence"
          }
      }

      let allRandomWords = ["THEO", "WWDC24", "SWIFTUI", "GESTURES", "ACCESSIBILITY", "HAPTICS"]
      let allRandomSentences = ["How are you?", "Are you attending WWDC?", "I am deafblind."]

      func addRandomElements() {
          addRandomWords()
          addRandomSentences()
      }

      private func addRandomWords() {
          var tempRandomWords: [String] = []
          var availableWords = allRandomWords

          for _ in 0..<2 {
              if let randomIndex = availableWords.indices.randomElement() {
                  let randomWord = availableWords.remove(at: randomIndex)
                  tempRandomWords.append(randomWord)
              }
          }

          randomWords = tempRandomWords
      }

      private func addRandomSentences() {
          var tempRandomSentences: [String] =  []
          var availableSentences = allRandomSentences

          for _ in 0..<1 {
              if let randomIndex = availableSentences.indices.randomElement() {
                  let randomSentence = availableSentences.remove(at: randomIndex)
                  tempRandomSentences.append(randomSentence)
              }
          }

          randomSentences = tempRandomSentences
      }
  //MARK: - Guess the number
  @Published var currentNumberGuessingIndex: Int = 0
  @Published var showActualNumber: Bool = false
  @Published var guessedNumber: Int?
  @Published var processingImage: UIImage = UIImage()

  var guessTheNumberPracticeDone: Bool {
    return currentNumberGuessingIndex > 3
  }

  //Analysis
  @Published var wrongGuesses: Int = 0
  @Published var wrightGuesses: Int = 0

  var guessedNumberMorse: String {
    return morseCode.encodeToMorse(String(guessedNumber ?? 0))
  }
  var actualNumberMorse: String {
    return morseCode.encodeToMorse(String(actualNumber))
  }
  var actualNumber: Int {
    return randomNumbers[currentNumberGuessingIndex]
  }

  var rightGuess: Bool {
    return guessedNumber == actualNumber
  }
  var wrongGuess: Bool {
    return guessedNumber != actualNumber
  }


  @Published var randomNumbers: [Int] = [2, 9, 0, 4, 5]

  func setRandomNumbers() {
          randomNumbers = (0..<5).map { _ in Int(arc4random_uniform(10)) }
    print("generated random numbers: \(randomNumbers)")
      }
  
  func checkGuess() {
    withAnimation {
      showActualNumber = true
      if guessedNumber == actualNumber {

      }
    }
  }
  func nextNumber() {
    showActualNumber = false
    withAnimation(.spring()) {
      guessedNumber = nil
      currentNumberGuessingIndex += 1
    }
  }
  //MARK: - MNIST Classifier

  func predictImage(image: UIImage) {
    do {

      if let resizedImage = image.fit(in: CGSize(width: 28, height: 28), background: .black), let pixelBuffer = resizedImage.toCVPixelBuffer() {
        self.processingImage = resizedImage
        let modelConfig = MLModelConfiguration()
        let model = try? MNISTClassifier(configuration: modelConfig)
        guard let result = try? model!.prediction(image: pixelBuffer) else {
          print("returning with no prediction made")
          return
        }
        print("result: \(result.classLabel)")
        guessedNumber = Int(result.classLabel)
        print("guessed number changed to \(guessedNumber)")
      }
    } catch {
      fatalError("an error appeared when trying to predict, error: \(error.localizedDescription)")
    }
  }
}
