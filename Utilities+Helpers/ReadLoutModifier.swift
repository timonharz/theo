//
//  File.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

// A ViewModifier that reads text out loud using AVSpeechSynthesizer
struct ReadAloudModifier: ViewModifier {
    @State private var highlightedRange: NSRange?
    @Binding var isReading: Bool // Binding to control the reading process

    let speak = Speak()

    let text: String

    func body(content: Content) -> some View {
        content
            .onAppear {
                if isReading {
                  speak.sayThis(text)
                }
            }
            .onChange(of: text) { newText in
                if isReading {
                  speak.sayThis(text)
                }
            }

            .modifier(HighlightTextModifier(highlightedRange: highlightedRange))
    }
}

// A ViewModifier to highlight text with a red color
struct HighlightTextModifier: ViewModifier {
    let highlightedRange: NSRange?

    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .overlay(
                TextOverlay(highlightedRange: highlightedRange)
            )
    }
}

// A view to overlay the text with highlighted portions
struct TextOverlay: View {
    let highlightedRange: NSRange?

    var body: some View {
        if let range = highlightedRange {
            Text("")
                .background(
                    GeometryReader { geometry in
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: geometry.size.width * CGFloat(range.length) / CGFloat(range.location + range.length), height: geometry.size.height)
                            .offset(x: CGFloat(range.location) * geometry.size.width / CGFloat(range.location + range.length), y: 0)
                    }
                )
                .allowsHitTesting(false) // Allow tap through
        } else {
            EmptyView()
        }
    }
}

// Extension to easily apply ReadAloudModifier to Text views
extension Text {
    func readAloud(text: String, isReading: Binding<Bool>) -> some View {
        self.modifier(ReadAloudModifier(isReading: isReading, text: text))
    }
}
