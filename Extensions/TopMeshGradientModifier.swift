//
//  File.swift
//  
//
//  Created by Timon Harz on 24.02.24.
//

import Foundation
import SwiftUI

struct TopMeshGradientModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
          ZStack {
            MeshGradient(colors: [color, color.opacity(0.8)], blurred: 60, animated: true, speed: 0)
            content
      }
    }
}
extension View {
  func meshGradientTop(color: Color) -> some View {
    self.modifier(TopMeshGradientModifier(color: color))
  }
}


#Preview {

    VStack {
      Text("test")
    }.frame(maxHeight: .infinity).meshGradientTop(color: Color("lightPurple"))
}
