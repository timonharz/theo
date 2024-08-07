//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import SwiftUI

struct MorseCodeView: View {
  var code: String
  var height: CGFloat
  var width: CGFloat
  var color: Color

  var splittedCode: [Character] {
    return Array(code)
  }

  let maxSymbolsPerLine = 30



  @StateObject var viewModel: MorseCodeModel = MorseCodeModel()
    var body: some View {
      VStack {
        HStack {
          ForEach(splittedCode.indices, id: \.self) { index in
            viewForSymbol(splittedCode[index])
          }
        }
      }
    }
  @ViewBuilder func viewForSymbol(_ symbol: Character) -> some View {
    VStack {
      switch symbol {
      case ".":
        Circle()
          .fill(color)
          .frame(width: width, height: width)
      case "-":
        RoundedRectangle(cornerRadius: 4)
          .fill(color)
          .frame(width: width * 2, height: height)
      case " ":
        RoundedRectangle(cornerRadius: 0)
          .fill(.clear)
          .frame(width: width, height: 2)
      case "|":
        RoundedRectangle(cornerRadius: 4)
          .fill(color)
          .frame(width: 4, height: height * 4)
      default:
        Color.clear
          .frame(width: width, height: height)
      }
    }
     }
}

#Preview {
  MorseCodeView(code: "...- -- | ..-.", height: 5, width: 10, color: Color("accentColor")).frame(maxWidth: 200)
}
