//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 15.02.24.
//

import SwiftUI
import AVFoundation

struct GestureReelView: View {
  @State var showExplanatioSheet: Bool = false

  @State var speakOut: Bool = false
  @State var readOutMorse: Bool = false

  @State private var speechSynthesizer: AVSpeechSynthesizer?

  @State var currentIndex: Int = 0
    var body: some View {
      HStack {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 20) {
            ForEach(gestureRecaps.indices, id: \.self) { index in
              Button(action: {
                self.currentIndex = index
                print("changed gesture reel index to: \(currentIndex)")
                self.showExplanatioSheet = true
              }) {
                gestureCardView(gesture: gestureRecaps[index])
                  .padding(.vertical)
              }.buttonStyle(ScaledButtonStyle(strength: .medium))
            }
          }.padding()
        }.frame(maxWidth: .infinity)
      }.sheet(isPresented: $showExplanatioSheet, content: {
        GestureExplanationSheet(index: $currentIndex)

      })
      .onChange(of: readOutMorse) { newVal in
        print("read out morse: \(newVal)")
      }
    }
  @ViewBuilder func gestureCardView(gesture: GestureRecapModel) -> some View {
    VStack {
      HStack {
        Image(gesture.icon)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(maxWidth: 50, maxHeight: 50)
      }.padding(.vertical)
      HStack {
        Text(gesture.title)
          .foregroundStyle(Color("textColor"))
          .font(.title3)
          .fontWeight(.semibold)
          .multilineTextAlignment(.leading)
        Spacer()
      }
    }.padding().frame(width: 200).frame(maxHeight: 300).background {
      RoundedRectangle(cornerRadius: 12).fill(.white).shadow(color: Color(.systemGray5), radius: 12, x: 0, y: 5)
    }
  }

}

#Preview {
    GestureReelView()
}
