//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 18.02.24.
//

import SwiftUI

struct TodoCellView: View {
  @ObservedObject var appState: AppState
    var body: some View {
      VStack(spacing: 15) {
        todoItem(label: "Guess the number practice", value: appState.guessTheNumberDone)
        Divider()
        todoItem(label: "Deleting words practice", value: appState.deletingWordsDone)
        Divider()
        todoItem(label: "Writing words practice", value: appState.writeAWordDone)
        Divider()
        todoItem(label: "Read How to use Theo", value: appState.readUserGuide)

      }.padding().background {
        RoundedRectangle(cornerRadius: 30).fill(.white).shadow(color: Color(.systemGray5), radius: 12, x: 0, y: 5)
      }
    }
  @ViewBuilder func todoItem(label: String, value: Bool) -> some View {
    HStack {
      Text(label)
        .foregroundStyle(Color("textColor"))
        .font(.title3)
        .fontWeight(.semibold)
        .padding(.leading)
        Spacer()
      if value {
        Image(systemName: "checkmark.circle.fill").resizable()
          .foregroundStyle(Color("accentColor"))
          .frame(width: 25, height: 25)

      } else {
        Circle().stroke(Color.gray, lineWidth: 1).frame(width: 25, height: 25)
      }
    }
  }
}

#Preview {
  ZStack {
    Color("BG").ignoresSafeArea(.all, edges: .all)
    TodoCellView(appState: AppState())
  }
}
