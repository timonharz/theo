//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI

struct TranscribeView: View {

  @Environment(\.dismiss) var dismiss

  @State private var colors: [Color] = [Color("accentColor"), Color("accentColor").opacity(0.6)]

  @State private var logoCirlceScale: CGFloat = 1.0
  @State private var ringsScale: CGFloat = 1.0
  @State private var ringsOpacity: CGFloat = 0

  @StateObject var speechRecognizer = SpeechRecognizer()

  @Binding var text: String
  @Binding var presented: Bool
    var body: some View {
      NavigationStack {
        ZStack {
          background.ignoresSafeArea(.all, edges: .all)
          VStack {
            topBar().padding()
            listeningIndicatorText.rotationEffect(.degrees(180)).padding()
            Spacer()
listeningButton
            Spacer()
            listeningIndicatorText.padding()
          }
        }
      }.onAppear(perform: {
        animateRings()
        speechRecognizer.transcribe()
      })
      .onChange(of: speechRecognizer.transcriptionEnded) { newValue in
        print("transcripted text: \(speechRecognizer.transcript)")
        if newValue {
          text = speechRecognizer.transcript
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            speechRecognizer.stopTranscribing()
            presented = false
            dismiss()
          }
        }
      }
      .onChange(of: speechRecognizer.transcript, perform: { newValue in
        text = newValue
        print("transcripted text: \(newValue)")
      })
      .onDisappear {
        speechRecognizer.stopTranscribing()
      }
    }

  var background: some View {
    ZStack {
      LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
    }
  }
  var listeningButton: some View {
    ZStack {
      Button(action: {}) {
        ZStack {

          Circle().fill(Color.white.opacity(0.4))
            .overlay(
              Circle().stroke(LinearGradient(colors: [Color.white, Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
            )
            .frame(maxWidth: 300)
        }.scaleEffect(logoCirlceScale)

      }
      circleRings
    }
  }
  var circleRings: some View {
    ZStack {
      Circle().fill(Color.white.opacity(0.3)).frame(width: 350)
      Circle().fill(Color.white.opacity(0.2)).frame(width: 500)
      //Circle().fill(Color.white.opacity(0.1)).frame(width: 600)
    }.scaleEffect(ringsScale).opacity(ringsOpacity)
  }
  var listeningIndicatorText: some View {
    HStack {
      Text("I am listening")
        .foregroundStyle(.white.opacity(0.8))
        .font(.system(size: 60))
        .fontWeight(.bold)
    }
  }
  @ViewBuilder func topBar() -> some View {
    HStack {
      Button(action: {
        dismiss()
      }) {
        Image(systemName: "xmark")
          .foregroundStyle(.gray)
          .font(.title3)
      }
      Spacer()
      Spacer()
    }
  }
  private  func animateBackground() {
    Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
      withAnimation(.easeInOut(duration: 2.0)) {
        colors.shuffle()
      }
    }
  }
  private func animateRings() {
    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
      withAnimation(.easeInOut(duration: 1.5)) {
        if logoCirlceScale == 0.7 {
          logoCirlceScale = 1.0
          ringsScale = 2.0
          ringsOpacity = 1.0
        } else {
          logoCirlceScale = 0.7
          ringsScale = 0.5
          ringsOpacity = 0
        }
      }
    }
  }
}
