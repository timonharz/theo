//
//  File.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import Foundation
import Combine

class MorseCodeModel: ObservableObject {
 
  let morseCodes: [Character: String] = [
        "A": ".-",     "B": "-...",   "C": "-.-.",   "D": "-..",
        "E": ".",      "F": "..-.",   "G": "--.",    "H": "....",
        "I": "..",     "J": ".---",   "K": "-.-",    "L": ".-..",
        "M": "--",     "N": "-.",     "O": "---",    "P": ".--.",
        "Q": "--.-",   "R": ".-.",    "S": "...",    "T": "-",
        "U": "..-",    "V": "...-",   "W": ".--",    "X": "-..-",
        "Y": "-.--",   "Z": "--..",
        "0": "-----",  "1": ".----",  "2": "..---",  "3": "...--",
        "4": "....-",  "5": ".....",  "6": "-....",  "7": "--...",
        "8": "---..",  "9": "----.",
        " ": " ",      ".": ".-.-.-", ",": "--..--", "?": "..--..", "|": " ", "!": "−·−·−"
    ]
  let morseSymbols: [MorseSymbol] = [
      MorseSymbol(symbol: "A", code: ".-"),
      MorseSymbol(symbol: "B", code: "-..."),
      MorseSymbol(symbol: "C", code: "-.-."),
      MorseSymbol(symbol: "D", code: "-.."),
      MorseSymbol(symbol: "E", code: "."),
      MorseSymbol(symbol: "F", code: "..-."),
      MorseSymbol(symbol: "G", code: "--."),
      MorseSymbol(symbol: "H", code: "...."),
      MorseSymbol(symbol: "I", code: ".."),
      MorseSymbol(symbol: "J", code: ".---"),
      MorseSymbol(symbol: "K", code: "-.-"),
      MorseSymbol(symbol: "L", code: ".-.."),
      MorseSymbol(symbol: "M", code: "--"),
      MorseSymbol(symbol: "N", code: "-."),
      MorseSymbol(symbol: "O", code: "---"),
      MorseSymbol(symbol: "P", code: ".--."),
      MorseSymbol(symbol: "Q", code: "--.-"),
      MorseSymbol(symbol: "R", code: ".-."),
      MorseSymbol(symbol: "S", code: "..."),
      MorseSymbol(symbol: "T", code: "-"),
      MorseSymbol(symbol: "U", code: "..-"),
      MorseSymbol(symbol: "V", code: "...-"),
      MorseSymbol(symbol: "W", code: ".--"),
      MorseSymbol(symbol: "X", code: "-..-"),
      MorseSymbol(symbol: "Y", code: "-.--"),
      MorseSymbol(symbol: "Z", code: "--.."),
      MorseSymbol(symbol: "0", code: "-----"),
      MorseSymbol(symbol: "1", code: ".----"),
      MorseSymbol(symbol: "2", code: "..---"),
      MorseSymbol(symbol: "3", code: "...--"),
      MorseSymbol(symbol: "4", code: "....-"),
      MorseSymbol(symbol: "5", code: "....."),
      MorseSymbol(symbol: "6", code: "-...."),
      MorseSymbol(symbol: "7", code: "--..."),
      MorseSymbol(symbol: "8", code: "---.."),
      MorseSymbol(symbol: "9", code: "----."),
      MorseSymbol(symbol: ".", code: ".-.-.-"),
      MorseSymbol(symbol: ",", code: "--..--"),
      MorseSymbol(symbol: "?", code: "..--.."),
      MorseSymbol(symbol: "!", code: "-.-.−")
  ]

    private let inverseMorseCodes: [String: Character]

  init() {
      inverseMorseCodes = Dictionary(morseCodes.map({ ($1, $0) }), uniquingKeysWith: { (first, _) in first })
  }

  func getCode(for character: Character) -> String? {
      let uppercaseCharacter = String(character)
      return morseCodes[Character(uppercaseCharacter)]
  }

    func getCharacter(for code: String) -> Character? {
        return inverseMorseCodes[code]
    }

  func encodeToMorse(_ text: String) -> String {
      var encodedCharacters = [String]()
    //print("uppercased input text for encodeToMorse: \(text.uppercased())")
    for character in text.uppercased() {
          if character == " " {
               // Treat a new word as "|"

            encodedCharacters.append("|")
            encodedCharacters.append(" ")
          } else if let morseCharacter = morseCodes[character] {
              encodedCharacters.append(morseCharacter)
           

          }

      }


    return encodedCharacters.joined(separator: " ")
  }

  func decodeFromMorse(_ morseCode: String) -> String {

    let codesArray = morseCode.components(separatedBy: " ")
    let codes = codesArray.map { String($0) }


      var decodedCharacters = [String]()

    for code in codes {
            if let character = inverseMorseCodes[code] {
                  decodedCharacters.append(String(character))
            }
      if code == "|" {
        decodedCharacters.append(" ")
      }
        }

      return decodedCharacters.joined()
  }
}
