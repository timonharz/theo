//
//  File.swift
//  
//
//  Created by Timon Harz on 15.02.24.
//

import Foundation
import SwiftUI
import Combine

struct GestureRecapModel: Identifiable, Hashable {
  var icon: String
  var title: String
  var description: String
  let id = UUID()
}

let gestureRecaps: [GestureRecapModel] = [
  GestureRecapModel(icon: "ShakeGesture", title: "Shake Gesture", description: "When shaking the device you will automatically switch to simple chat, no matter which tab you are in. If you got lost inside one of the tabs and dont know where you are this will return you to the chat."),
  GestureRecapModel(icon: "TapGesture", title: "Tap Gesture", description: "Tap to add a dot to the Morse code you are writing. You get tactile feedback when you add a dot."),
  GestureRecapModel(icon: "DoubleTapGesture", title: "Double Tap", description: "Tap twice to start a new character in the morse code you are writing."),
  GestureRecapModel(icon: "LongPressGesture", title: "Long Press", description: "Press and hold to add a new word to the Morse code you are writing. You will not receive tactile feedback for this interaction."),
  GestureRecapModel(icon: "SwipeRightGesture", title: "Swipe Right", description: "Swipe right to add a line to the Morse code you are writing. You get tactile feedback when you add a line."),
  GestureRecapModel(icon: "SwipeLeftGesture", title: "Swipe Left", description: "Swipe left to delete the last character you have written. You will not receive tactile feedback for this."),
  GestureRecapModel(icon: "ZoomInGesture", title: "Pinch In", description: "Pinch in to the morse code you are writing to get a tactile feedback of what you have already written."),
  GestureRecapModel(icon: "ZoomOutGesture", title: "Pinch Out", description: "Pinch out to speak out loudly what you wrote to others."),
  GestureRecapModel(icon: "SwipeUpGesture", title: "Swipe Up", description: "Swipe up to open the simple chat view. Swipe up again to start transcribing."),
  GestureRecapModel(icon: "SwipeDownGesture", title: "Swipe Down", description: "Swipe down to close the simple chat view.")
]
