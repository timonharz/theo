//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 20.02.24.
//

import SwiftUI

struct TextRecognitionCameraView: View {

  @Binding var didTakePicture: Bool

  @ObservedObject var viewModel: TextRecogntionViewModel
    var body: some View {
      ZStack(alignment: .bottom) {
       // Color.black.ignoresSafeArea(.all, edges: .all)
        CustomCameraRepresentable(image: $viewModel.inputImage, didTapCapture: $didTakePicture).ignoresSafeArea(.all, edges: .all)
        takePhotoButton().padding().padding(.bottom)
      }
    }
  @ViewBuilder func takePhotoButton() -> some View {
    HStack {
      Button(action: {
        self.didTakePicture = true
      //  viewModel.recognizeText()
      }) {
        Circle()
          .fill(Color.gray.opacity(0.6))
          .blur(radius: 2)
          .frame(width: 70, height: 70)
          .overlay {
            Circle().stroke(.white, lineWidth: 5)
          }
      }
    }
  }
}
#Preview {
  ZStack {
    Color.black.ignoresSafeArea(.all, edges: .all)
    TextRecognitionCameraView(didTakePicture: .constant(false), viewModel: TextRecogntionViewModel()).takePhotoButton()
  }
}
