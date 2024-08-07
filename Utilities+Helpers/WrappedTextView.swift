//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import SwiftUI

struct WrappedTextView: View {
    let text: String
    let maxCharactersPerLine: Int

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(wrapText(), id: \.self) { line in
                Text(line)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.trailing)
            }
        }
    }

    private func wrapText() -> [String] {
        var lines = [String]()
        var currentLine = ""
        var remainingText = text

        while !remainingText.isEmpty {
            let nextLineLength = min(maxCharactersPerLine, remainingText.count)
            let nextLine = String(remainingText.prefix(nextLineLength))
            remainingText.removeFirst(nextLineLength)

            if !currentLine.isEmpty {
                currentLine.append(" ") // Add space between lines
            }
            currentLine.append(nextLine)

            if currentLine.count >= maxCharactersPerLine || remainingText.isEmpty {
                lines.append(currentLine)
                currentLine = ""
            }
        }

        return lines
    }
}
#Preview {
  WrappedTextView(text: "elhw kthrkj herkjth kerjth kerjth krejht krejht kerjth kejrt", maxCharactersPerLine: 5)
}
