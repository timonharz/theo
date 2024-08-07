//
//  File.swift
//  
//
//  Created by Timon Harz on 15.02.24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

final class AppState: ObservableObject {
  @Published var showSettings: Bool = false

  @Published var speechSynthesizer: AVSpeechSynthesizer?

  @AppStorage("settings_preferedVoice") var preferedVoice: String = ""
  @AppStorage("settings_voiceRate") var voiceRate: Double = 0.5

  @AppStorage("settings_dotLength") var dotLength: Double = 1
  @AppStorage("settings_lineLength") var lineLength: Double = 2

  @AppStorage("settings_isActiveListeningOn") var activeListeningOn: Bool = false

  @AppStorage("userIsDeaf") var userIsDeaf: Bool = false
  @AppStorage("userIsDeafblind") var userIsDeafBlind: Bool = false

  //MARK: - Todos
  @AppStorage("pratices_guessTheNumberDone") var guessTheNumberDone: Bool = false
  @AppStorage("pratices_deletingWordsDone") var deletingWordsDone: Bool = false
  @AppStorage("pratices_writeAWordDone") var writeAWordDone: Bool = false

  @AppStorage("articles_readAboutHK") var readHKArticle: Bool = false
  @AppStorage("articles_readUnderStandingDeafblindness") var readUnderderstadningDeafBlidness: Bool = false
  @AppStorage("articles_theoUserGuide") var readUserGuide: Bool = false


}
