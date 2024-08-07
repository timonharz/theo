//
//  File.swift
//  
//
//  Created by Timon Harz on 19.02.24.
//

import Foundation
import SwiftUI
import Vision

class TextRecogntionViewModel: ObservableObject {

  @Published var recognizedText: String = ""
  @Published var inputImage: UIImage?
  @Published var textRecognitionperformed: Bool = false
  @Published var didTakePicture: Bool = false
  @Published var isLoading: Bool = false

  let textAnalysis = TextAnalysis.shared
  let morseCode = MorseCodeModel()

  var resultTextLanguageCode: String {
    return textAnalysis.detectLanguage(text: recognizedText)
  }
  var resultTextLanguage: String {
    return textAnalysis.languageNameForCode(resultTextLanguageCode)
  }

  var resultTextMorse: String {
    return morseCode.encodeToMorse(recognizedText)
  }

  var recognizedTextEmpty: Bool {
    recognizedText.isEmpty
  }

  @Published var showHighCharacterWarning: Bool = false

     func recognizeText() {
       isLoading = true
         // Create a Vision request handler
       guard inputImage != nil else { return }
       guard let cgImage = inputImage?.cgImage else { return }
         let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

         // Create a text recognition request
         let textRecognitionRequest = VNRecognizeTextRequest { request, error in
           guard let observations = request.results as? [VNRecognizedTextObservation] else {
             self.isLoading = false
             return
           }

             // Process the recognized text
             let recognizedStrings = observations.compactMap { observation in
                 return observation.topCandidates(1).first?.string
             }

             // Update the recognized text
             DispatchQueue.main.async {
                 self.recognizedText = recognizedStrings.joined(separator: "\n")
             }
         }

         // Perform the text recognition request
         do {
             try requestHandler.perform([textRecognitionRequest])
           withAnimation {
             self.textRecognitionperformed = true
             self.isLoading = false
           }
         } catch {
             print("Error: \(error.localizedDescription)")
         }
       isLoading = false
     }
}
