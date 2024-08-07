//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import SwiftUI

struct PracticeReelView: View {
  @State var selectedIndex: Int = 0

  @State private var showPractice: Bool = false
    var body: some View {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
          ForEach(availablePractices.indices, id: \.self) { index in
            Button(action: {
              self.selectedIndex = index
              print("changed selected index to : \(selectedIndex)")
              self.showPractice = true
            }) {
              practiceCard(practice: availablePractices[index]).padding()
                /*.overlay(

                  Text("PRACTICE")
                    .foregroundStyle(.secondary)
                    .font(.headline)
                    .fontWeight(.semibold).padding(.top, 30).padding(.trailing, 30), alignment: .topTrailing
                )*/
            }.buttonStyle(ScaledButtonStyle(strength: .medium))
          }

        }
      }.frame(maxWidth: .infinity)

        .sheet(isPresented: $showPractice) {
          PracticePreviewView(index: $selectedIndex).onAppear {
            print("selected index: \(selectedIndex)")
          }
        }
    }
  @ViewBuilder func practiceCard(practice: PracticeModel) -> some View {
    VStack {
      HStack {
        Image(practice.coverImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: 200)
          .clipShape(RoundedRectangle(cornerRadius: 22))
      }
      HStack {
        Text(practice.title)
          .foregroundStyle(Color("textColor"))
          .font(.title)
          .fontWeight(.semibold)
          .padding(.leading)
        Spacer()
      }
    }
  }
}

#Preview {
    PracticeReelView()
}
