//
//  File.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import Foundation
import SwiftUI

struct Paragraph: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var textContent: String // Convert AttributedString to String
    var attributedTextContent: AttributedString
  var quote: Quote
    var images: [ParagraphImage]
    var customView: AnyView // Corrected the typo in customView

    // Implementing custom Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(textContent)
        hasher.combine(images)
    }
  // Implementing custom Equatable conformance
      static func == (lhs: Paragraph, rhs: Paragraph) -> Bool {
          return lhs.id == rhs.id &&
                 lhs.title == rhs.title &&
                 lhs.textContent == rhs.textContent &&
                 lhs.images == rhs.images
      }
}

struct ParagraphImage: Identifiable, Hashable {
    let id = UUID()
    var images: [String]
    var subtitle: String
    var copyright: String
}
//MARK: - Quote

struct Quote: Identifiable, Hashable {
  var quoteTextContent: String
  var by: String
  var showApostrophe: Bool
  let id = UUID()
}
