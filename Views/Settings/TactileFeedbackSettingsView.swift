//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 17.02.24.
//

import SwiftUI

struct TactileFeedbackSettingsView: View {
  @EnvironmentObject var appState: AppState

  @State private var selectedDotLength: TactileFeedbackDotDuration = .mid
  @State private var selectedLineLength: TactileFeedbackLineDuration = .mid
    var body: some View {
      NavigationStack {
        VStack {
          List {
            Section(footer: Text("If you're new to Theo I recommend to set the length to very long.")) {
              Picker("Dot length", selection: $selectedDotLength) {
                ForEach(TactileFeedbackDotDuration.allCases, id: \.self) { duration in
                  Text(duration.description)
                }
              }
              Picker("Line length", selection: $selectedLineLength) {
                ForEach(TactileFeedbackLineDuration.allCases, id: \.self) { duration in
                  Text(duration.description)
                }
              }
            }
          }.onChange(of: selectedDotLength) { newVal in
            setLength()
          }
          .onChange(of: selectedLineLength) { newVal in
            setLength()
          }
        }.navigationTitle("Tactile feedback").navigationBarTitleDisplayMode(.large)
      }.onAppear(perform: {
        getLength()
      })
    }
  private func getLength() {
    let dotLengthMapping: [Float: TactileFeedbackDotDuration] = [
            0.2: .veryShort,
            0.5: .short,
            1.0: .mid,
            2.0: .long,
            2.5: .veryLong
        ]

    if let selectedLength = dotLengthMapping[Float(appState.dotLength)] {
            self.selectedDotLength = selectedLength
        }

    let lineLengthMapping: [Float: TactileFeedbackLineDuration] = [
      0.5: .veryLong,
      1.0: .short,
      2.0: .mid,
      3.0: .long,
      4.0: .veryLong
    ]
    if let selectedLineLengthItem = lineLengthMapping[Float(appState.lineLength)] {
      self.selectedLineLength = selectedLineLengthItem
    }
  }
  private func setLength() {
    appState.dotLength = Double(selectedDotLength.rawValue)
    appState.lineLength = Double(selectedLineLength.rawValue)
  }
}

#Preview {
  TactileFeedbackSettingsView().environmentObject(AppState())
}
