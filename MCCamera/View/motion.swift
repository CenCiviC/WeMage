//
//  motion.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/09.
//

import SwiftUI
import CoreMotion

class MotionManager {
    let motionManager = CMMotionManager()

    init() {
        // Configure the motion manager with desired settings
        motionManager.accelerometerUpdateInterval = 1
    }

    func startMotionUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                // Process accelerometer data here
                if let accelerometerData = data {
                    // Handle accelerometer data updates
                }
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}


