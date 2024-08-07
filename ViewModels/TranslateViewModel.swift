//
//  File.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import Foundation
import SwiftUI
import Combine

final class TranslateViewModel: ObservableObject {
  @Published var soundDetected: Bool = false
  @Published var showTranscribeView: Bool = false
  @Published var lastSheetPresentationState: Bool = false
  @Published var currentSpeaker: ConversationSpeaker = .you
  @Published var currentListener: ConversationSpeaker = .they
  @Published var focusCanvas: Bool = false


  @AppStorage("settings_showTokenizeIntroduction") var showedTokenizeIntroduction: Bool = false

  @AppStorage("chat_showCasingDone") var showCasingDone: Bool = false

  let textAnalyis = TextAnalysis.shared

  //sheets
  @Published var showCameraView: Bool = false
  @Published var showSettings: Bool = false

  let morseCode = MorseCodeModel()

  //MARK: - Chat
  @Published var speakerTextFieldText: String = ""
  @Published var listenerTextFieldText: String = ""
  @Published var speakerLanguage: String = ""

  //MARK: - Morse codes for textfield
  @Published var speakerTextFieldMorse: String = ""
  @Published var listenerTextFieldMorse: String = ""
  @Published var listenerLanguage: String = ""

  @Published var showTokenizeSheet: Bool = false

  var showSpeakerLanguage: Bool {
    return speakerLanguage.isEmpty == false
  }
  var showListenerLanguage: Bool {
    return listenerLanguage.isEmpty == false
  }
  var showTokenizeOption: Bool {
    return listenerTextFieldText.isEmpty == false
  }

  func getLanguages() {
    withAnimation {
      speakerLanguage = textAnalyis.detectLanguage(text: speakerTextFieldText).uppercased()
      listenerLanguage = textAnalyis.detectLanguage(text: listenerTextFieldText).uppercased()
    }
  }

}
