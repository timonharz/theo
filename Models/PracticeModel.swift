//
//  File.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import Foundation
import SwiftUI
import Combine

struct PracticeModel: Identifiable, Hashable {
  var title: String
  var description: String
  var coverImage: String
  var practiceType: PracticeType
  var level: PracticeLevel
  let id = UUID()
}

enum PracticeType {
  case guessNumber
  //case guessTheWord
  case deleteWord
  case writeGivenWord
}
enum PracticeLevel {
  case easy
  case medium
  case hard

  var description: String {
    switch self {
    case .easy:
      return "Easy"
    case .medium:
      return "Medium"
    case .hard:
      return "Hard"
    }
  }
  var color: Color {
    switch self {
    case .easy:
      return .green
    case .medium:
      return .yellow
    case .hard:
      return .red
    }
  }
}

let availablePractices: [PracticeModel] = [
  PracticeModel(title: "Guess the number", description: "Try to guess the number you feel and sketch the number down on the canvas. This practice helps you differenciate numbers from letters. This practice is intended to be done with a caregiver.", coverImage: "CoverGuessTheNumber", practiceType: .guessNumber, level: .medium),
  PracticeModel(title: "Deleting words", description: "Practice deleting words with swipe gestures in theo to improve your muscle memory and interaction speed over time. This practice is intended to be done with a caregiver.", coverImage: "CoverDeletingAWord2", practiceType: .deleteWord, level: .easy),
  PracticeModel(title: "Write a word", description: "Write a given word in theo using only morse code. This will give you a deeper understanding of the letters and how they feel. This practice is intended to be done with a caregiver.", coverImage: "CoverWriteTheWord", practiceType: .writeGivenWord, level: .hard)
]

