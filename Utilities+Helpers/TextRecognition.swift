//
//  File.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import Foundation
import SwiftUI
import Vision

struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var viewModel: TranslateViewModel
    var didFinishRecognition: () -> Void


    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else { return }

                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

                do {
                    let textItem = TextItem()
                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])

                    DispatchQueue.main.async {
                      viewModel.listenerTextFieldText = textItem.text
                    }
                } catch {
                    print(error.localizedDescription)
                }

                DispatchQueue.main.async {
                    didFinishRecognition()
                }
            }
        }
    }


    private func getTextRecognitionRequest(with textItem: TextItem) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                textItem.text += recognizedText.string
                textItem.text += "\n"
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        return request
    }
}
class TextItem: Identifiable {
    var id: String
    var text: String = ""

    init() {
        id = UUID().uuidString
    }
}
