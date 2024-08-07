//
//  File.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import Foundation
import CoreHaptics
import UIKit

class SpeechVibrationManager {
  let generator = UIImpactFeedbackGenerator(style: .soft)

    func startVibrating() {
        generator.prepare()
        generator.impactOccurred()
    }

    func stopVibrating() {
        generator.prepare()
    }
}
