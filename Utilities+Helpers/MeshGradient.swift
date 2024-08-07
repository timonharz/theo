//
//  File.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import Foundation
import SwiftUI

struct MeshGradient: View {
    @State var colors: [Color]
    var blurred: CGFloat
    var animated: Bool
    var speed: Double
    @State private var angle = Angle.degrees(0)
    var body: some View {
        var gradient = Gradient(colors: colors)
        ZStack {
            AngularGradient(gradient: gradient,
                                    center: .center,
                                    angle: angle)
                .blur(radius: blurred)
        }.onAppear {
            if animated {
              withAnimation(.linear(duration: speed).repeatForever(autoreverses: true)) {
                                angle = .degrees(360)
                                colors.shuffle()
                           }
                       }
        }
    }
}

