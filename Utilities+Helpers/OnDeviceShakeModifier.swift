//
//  File.swift
//  
//
//  Created by Timon Harz on 15.02.24.
//

import Foundation
import CoreMotion
import SwiftUI

struct OnDeviceShakeModifier: ViewModifier {
    let motionManager = CMMotionManager()
    let updateInterval = 0.1 // Update interval in seconds
    let shakeThreshold = 1.5 // Threshold for shake detection

    private var action: () -> Void

    @State private var isShaking = false

    init(action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                startShakeDetection()
            }
            .onDisappear {
                stopShakeDetection()
            }
            .onChange(of: isShaking) { newValue in
                if newValue {
                    action()
                }
            }
    }

    private func startShakeDetection() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = updateInterval
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let acceleration = data?.acceleration, error == nil {
                    let totalAcceleration = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))

                    if totalAcceleration >= shakeThreshold {
                        isShaking = true
                    } else {
                        isShaking = false
                    }
                }
            }
        } else {
            print("Accelerometer is not available")
        }
    }

    private func stopShakeDetection() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}

extension View {
    func onDeviceShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(OnDeviceShakeModifier(action: action))
    }
}
