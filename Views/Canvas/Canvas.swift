//
//  File.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import Foundation
import PencilKit
import SwiftUI

struct PKCanvasRepresentation: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // You can update the view if needed
    }
}
