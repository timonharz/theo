//
//  File.swift
//  
//
//  Created by Timon Harz on 25.02.24.
//

import Foundation
import SwiftUI

struct Highlight: Identifiable, Equatable {
  var id: UUID = .init()
  var anchor: Anchor<CGRect>
  var title: String
  var cornerRadius: CGFloat
  var style: RoundedCornerStyle = .continuous
  var scale: CGFloat = 1
}
