//
//  File.swift
//  
//
//  Created by Timon Harz on 18.02.24.
//

import Foundation
import NaturalLanguage
import SwiftUI

class TextAnalysis {
  static let shared = TextAnalysis()


  init() {

  }
  //analyze sentiment of the given text
      func analyzeSentiment(text: String) {
          let tagger = NLTagger(tagSchemes: [.sentimentScore])
          tagger.string = text

          let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)

          if let sentiment = sentiment {
              print("Sentiment Score: \(sentiment.rawValue)")
          } else {
              print("Unable to analyze sentiment")
          }
      }
  //get language of the given text
     func detectLanguage(text: String) -> String {
         let recognizer = NLLanguageRecognizer()
         recognizer.processString(text)

         if let languageCode = recognizer.dominantLanguage?.rawValue {

             print("Detected Language: \(languageCode)")
           return languageCode
         } else {
             print("Unable to detect language")
         }
       return ""
     }
  func tokenizeText(text: String) -> [String] {
          let tokenizer = NLTokenizer(unit: .word)
          tokenizer.string = text

          var tokens: [String] = []
          tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
              let token = String(text[tokenRange])
              tokens.append(token)
              return true
          }

          return tokens
      }
  func languageNameForCode(_ languageCode: String) -> String {
    switch languageCode {
        case "en":
          return "English"
        case "de":
          return "German"
        case "fr":
          return "French"
        case "es":
          return "Spanish"
        case "it":
          return "Italian"
        case "pt":
          return "Portuguese"
        case "nl":
          return "Dutch"
        case "ja":
          return "Japanese"
        case "ko":
          return "Korean"
        case "zh-Hans":
          return "Chinese (Simplified)"
        case "zh-Hant":
          return "Chinese (Traditional)"
        case "ru":
          return "Russian"
        case "ar":
          return "Arabic"
        case "hi":
          return "Hindi"
        case "tr":
          return "Turkish"
        case "sv":
          return "Swedish"
        case "fi":
          return "Finnish"
        case "no":
          return "Norwegian"
        case "da":
          return "Danish"
        case "pl":
          return "Polish"
        case "cs":
          return "Czech"
        case "hu":
          return "Hungarian"
        case "ro":
          return "Romanian"
        case "el":
          return "Greek"
        case "th":
          return "Thai"
        case "he":
          return "Hebrew"
        case "id":
          return "Indonesian"
        case "ms":
          return "Malay"
        case "vi":
          return "Vietnamese"
        case "uk":
          return "Ukrainian"
        case "bg":
          return "Bulgarian"
        case "sk":
          return "Slovak"
        case "sl":
          return "Slovenian"
        case "hr":
          return "Croatian"
        case "sr":
          return "Serbian"
        case "et":
          return "Estonian"
        case "lv":
          return "Latvian"
        case "lt":
          return "Lithuanian"
        case "sq":
          return "Albanian"
        case "mk":
          return "Macedonian"
        case "bn":
          return "Bengali"
        case "ta":
          return "Tamil"
        case "te":
          return "Telugu"
        case "ml":
          return "Malayalam"
        case "kn":
          return "Kannada"
        case "gu":
          return "Gujarati"
        case "mr":
          return "Marathi"
        case "pa":
          return "Punjabi"
        case "ne":
          return "Nepali"
        case "si":
          return "Sinhala"
        case "my":
          return "Burmese"
        case "km":
          return "Khmer"
        // Add more language codes and names as needed
        default:
          return "Unknown"
        }

  }
  //

}

#Preview {
  VStack {
    Button(action: {
      let textAnalysis = TextAnalysis.shared
      let language = textAnalysis.detectLanguage(text: "Hello World.")
      print(language)
    }) {
      Text("Detect language")
    }
  }
}
