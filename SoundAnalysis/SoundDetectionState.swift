//
//  File.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import Foundation

struct DetectionState {
    /// The confidence threshold that considers a sound present.
    let presenceThreshold: Double

    /// The confidence threshold that considers a sound absent.
    let absenceThreshold: Double

    /// The number of consecutive presence measurements necessary to begin detection.
    let presenceMeasurementsToStartDetection: Int

    /// The number of consecutive absence measurements necessary to end detection.
    let absenceMeasurementsToEndDetection: Int

    /// Indicates whether the app detects a sound.
    var isDetected = false

    /// The app contains inertia values that prevent changing the state of `isDetected` immediately.
    /// This value indicates the progress toward changing its state.
    var transitionProgress = 0

    /// The most recent confidence measurement for the sound.
    var currentConfidence = 0.0

    /// Creates a detection state with a confidence of zero, and a state that indicates the system doesn't detect a sound.
    init(presenceThreshold: Double,
         absenceThreshold: Double,
         presenceMeasurementsToStartDetection: Int,
         absenceMeasurementsToEndDetection: Int) {
        self.presenceThreshold = presenceThreshold
        self.absenceThreshold = absenceThreshold
        self.presenceMeasurementsToStartDetection = presenceMeasurementsToStartDetection
        self.absenceMeasurementsToEndDetection = absenceMeasurementsToEndDetection
    }

    /// Creates a detection state with a confidence measurement.
    ///
    /// - Parameters:
    ///   - prevState: The state from which to derive a new detection state. The difference relies on the
    ///     confidence measurement that the system provides to the `currentConfidence` argument.
    ///   - currentConfidence: A confidence measurement that reflects whether the system detects
    ///     a sound according to the latest observation.
    init(advancedFrom prevState: DetectionState,
         currentConfidence: Double) {
        isDetected = prevState.isDetected
        transitionProgress = prevState.transitionProgress
        presenceThreshold = prevState.presenceThreshold
        absenceThreshold = prevState.absenceThreshold
        presenceMeasurementsToStartDetection = prevState.presenceMeasurementsToStartDetection
        absenceMeasurementsToEndDetection = prevState.absenceMeasurementsToEndDetection

        if isDetected {
            if currentConfidence < absenceThreshold {
                transitionProgress += 1
            } else {
                transitionProgress = 0
            }

            if transitionProgress >= absenceMeasurementsToEndDetection {
                isDetected = !isDetected
                transitionProgress = 0
            }
        } else {
            if currentConfidence > presenceThreshold {
                transitionProgress += 1
            } else {
                transitionProgress = 0
            }

            if transitionProgress >= presenceMeasurementsToStartDetection {
                isDetected = !isDetected
                transitionProgress = 0
            }
        }

        self.currentConfidence = currentConfidence
    }
}
