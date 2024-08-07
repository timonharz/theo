//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 10.02.24.
//

import SwiftUI
import AVFoundation

struct MorseCanvasIntroductionView: View {
  @ObservedObject var viewModel: OnboardingViewModel

  @StateObject var morseViewModel: MorseCodeModel = MorseCodeModel()

  let hapticEngine = HapticEngine.shared
  let speak = Speak()


    var body: some View {
      NavigationStack {
        ZStack {
          Color("BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            HStack {
              Image("LogoHorizontal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100)
            }.padding(.top)
            Spacer()
            if viewModel.showResult {
              resultView
            } else {
              VStack {
                HStack {
                  walkthrough
                }
                VStack {
                  MorseCodeView(code: viewModel.morseCanvasIntroductionCode, height: 10, width: 20, color: Color("textColor"))
                }
              }
            }
            Spacer()
            HStack {
              if (viewModel.morseWalkthroughState == .result || viewModel.morseWalkthroughState == .delete) && viewModel.showResult == false {
                Button(action: {
                  viewModel.morseCanvasIntroductionCode.removeLast()
                  viewModel.result = morseViewModel.decodeFromMorse(viewModel.morseCanvasIntroductionCode)
                  print("result: \(viewModel.result)")
                  withAnimation {
                    viewModel.showResult = true
                  }
                }) {
                  Text("Show Result")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: getRect().width - 150)
                    .padding(.vertical)
                    .background {
                      RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                    }
                }.buttonStyle(ScaledButtonStyle(strength: .soft))
              }
              if viewModel.showResult {
                Button(action: {
                  viewModel.morseCanvasIntroductionCode.removeLast()
                  withAnimation {
                    viewModel.continueWalkthough = true
                    viewModel.showResult = false
                    viewModel.morseWalkthroughState = .space
                  }
                }) {
                  Text("Learn more gestures")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: getRect().width - 150)
                    .padding(.vertical)
                    .background {
                      RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                    }
                }.buttonStyle(ScaledButtonStyle(strength: .soft))
              }
              if viewModel.detailedWalkthroughEnded {
                Button(action: {
                  viewModel.animate(next: .morseDictionaryIntroduction)
                }) {
                  Text("Next")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: getRect().width - 150)
                    .padding(.vertical)
                    .background {
                      RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                    }
                }.buttonStyle(ScaledButtonStyle(strength: .soft))
              }
            }.padding(.bottom)
          }
        }
        .simultaneousGesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
          .onEnded { value in
                          let horizontalAmount = value.translation.width
                          let verticalAmount = value.translation.height

                          if abs(horizontalAmount) > abs(verticalAmount) {
                              print(horizontalAmount < 0 ? "left swipe" : "right swipe")
                            if horizontalAmount > 0 {
                              withAnimation(.easeInOut(duration: 0.1)) {
                                if viewModel.continueWalkthough == false {
                                  viewModel.morseWalkthroughState = .delete
                                }
                                viewModel.morseCanvasIntroductionCode.append("-")
                                hapticEngine.playMorseCode("-")
                              }
                            }
                            if horizontalAmount < 0 {
                              withAnimation(.easeOut(duration: 0.1)) {
                                guard !viewModel.morseCanvasIntroductionCode.isEmpty else { return }
                                viewModel.morseCanvasIntroductionCode.removeLast()
                                if viewModel.morseWalkthroughState != .addLine && viewModel.continueWalkthough == false {
                                  withAnimation {
                                    viewModel.morseWalkthroughState = .result
                                  }
                                }
                              }
                            }
                          } else {
                              print(verticalAmount < 0 ? "up swipe" : "down swipe")
                          }
                      })
        .highPriorityGesture(
          TapGesture(count: 2).onEnded {
            viewModel.morseCanvasIntroductionCode.removeLast()
            withAnimation(.easeInOut(duration: 0.1)) {
              
              viewModel.morseCanvasIntroductionCode.append(" ")
              if viewModel.continueWalkthough == true {
                viewModel.morseWalkthroughState = .feel
              }
            }
          }
        )
        .simultaneousGesture(
          LongPressGesture().onEnded({ state in
            viewModel.result = morseViewModel.decodeFromMorse(viewModel.morseCanvasIntroductionCode)
            viewModel.morseCanvasIntroductionCode.append("|")
          })
        )
        .simultaneousGesture(
          TapGesture(count: 1).onEnded({ function in
            withAnimation(.easeInOut(duration: 0.1)) {
                viewModel.morseCanvasIntroductionCode.append(".")
              hapticEngine.playMorseCode(".")
              if viewModel.morseWalkthroughState == .addDot {
                withAnimation {
                  if viewModel.continueWalkthough == false {
                    viewModel.morseWalkthroughState = .addLine
                  }
                }
              }

            }
          })
        )
        .simultaneousGesture(
          MagnificationGesture().onEnded { value in
            if value > 1 {
              hapticEngine.playMorseCode(viewModel.morseCanvasIntroductionCode)
            } else if value < 1 {
              speak.sayThis(viewModel.morseCanvasCodeText)
            }
            withAnimation(.easeIn(duration: 0.1)) {
              if viewModel.continueWalkthough {
                viewModel.detailedWalkthroughEnded = true
              }
            }
          }
        )
      }
    }
  var walkthrough: some View {
    VStack {
      if viewModel.morseWalkthroughState == .addLine {
        Text("\(Text("**Swipe right**").foregroundColor(Color("accentColor"))) to add a line.")
          .font(.system(size: 60))
          .foregroundStyle(Color("textColor"))
      } else if viewModel.morseWalkthroughState == .addDot{
        Text("\(Text("**Tap**").foregroundColor(Color("accentColor"))) to write a dot.")
          .font(.system(size: 60))
          .foregroundStyle(Color("textColor"))
      } else if viewModel.morseWalkthroughState == .delete || viewModel.morseWalkthroughState == .result {
        Text("\(Text("**Swipe left**").foregroundColor(Color("accentColor"))) to delete the last character.")
          .font(.system(size: 60))
          .foregroundStyle(Color("textColor"))
      } else if viewModel.morseWalkthroughState == .tapAndHold {
        Text("\(Text("**Long tap**").foregroundColor(Color("accentColor"))) to start a new word.")
          .font(.system(size: 60))
          .foregroundStyle(Color("textColor"))
      } else if viewModel.morseWalkthroughState == .reset {
        Text("\(Text("**Swipe with two fingers**").foregroundColor(Color("accentColor"))) to the left to reset.")
          .font(.system(size: 60))
          .foregroundStyle(Color("textColor"))
      } else if viewModel.morseWalkthroughState == .space {
        Text("\(Text("**Double Tap**").foregroundColor(Color("accentColor"))) to start a new character.")
          .font(.system(size: 60))
          .foregroundStyle(Color("textColor"))
      } else if viewModel.morseWalkthroughState == .feel {
        Text("\(Text("**Zoom in**").foregroundColor(Color("accentColor"))) to feel the morse code.")
          .font(.system(size: 60))
          .foregroundStyle(Color("textColor"))
      }
    }
  }
  var resultView: some View {
    VStack {
      HStack {
        MorseCodeView(code: viewModel.morseCanvasIntroductionCode, height: 30, width: 60, color: Color("textColor"))
      }
      HStack {
        VStack(alignment: .center) {
          Text("Congrats!")
          Text("You just wrote a")
        }.foregroundStyle(Color("textColor")).font(.largeTitle).fontWeight(.semibold)
      }.padding()
      
      HStack {
        Text(viewModel.result)
          .foregroundStyle(.white)
          .font(.system(size: 120))
          .fontWeight(.bold)
          .padding()
          .background {
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.gray.opacity(0.2))

          }
      }.padding()

    }
  }
}

#Preview {
  MorseCanvasIntroductionView(viewModel: OnboardingViewModel())
}
#Preview {
  MorseCanvasIntroductionView(viewModel: OnboardingViewModel()).resultView
}
