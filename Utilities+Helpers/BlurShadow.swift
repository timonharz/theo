//
//  File.swift
//  
//
//  Created by Timon Harz on 15.02.24.
//

import Foundation
import SwiftUI

struct BlurShadow: ViewModifier {
    @Environment(\.colorScheme) var appearance
    func body(content: Content) -> some View {
        return content
            .shadow(color: appearance == .light ? Color.gray.opacity(0.5) : .clear, radius: 6, x: 0, y: 8)
    }
}
