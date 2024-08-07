//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import SwiftUI
import PencilKit

struct PracticeView: View {

  @StateObject var viewModel = PracticeViewModel()

  @State var canvasView = PKCanvasView()

  @AppStorage("pratices_guessTheNumberDone") var guessTheNumberDone: Bool = false
  @AppStorage("pratices_deletingWordsDone") var deletingWordDone: Bool = false
  @AppStorage("pratices_writeAWordDone") var writeAWordDone: Bool = false

  let hapticEngine = HapticEngine.shared

  //MARK: - Animation
  @State private var gestureIndicatorXOffset: CGFloat = 0
  @State private var showGestureIndicator: Bool = false

  var canvasEmpty: Bool {
    return canvasView.drawing.strokes.isEmpty
  }

  @State private var inputImage: UIImage = UIImage()

  @Environment(\.dismiss) var dismiss
  var practice: PracticeModel
  
    var body: some View {
      NavigationStack {
        ZStack {
          Color("BG").ignoresSafeArea(.all, edges: .all)
          VStack {
            topSection().padding(.top)
            Spacer()
            switch practice.practiceType {
            case .guessNumber:
              guessTheNumber()
            case .deleteWord:
              deletingWords()
            case .writeGivenWord:
              writingWords()
            }
            Spacer()
          }
        }

      }.onAppear(perform: {
        viewModel.setRandomNumbers()
        viewModel.randomNumbers.shuffle()
        viewModel.addRandomElements()
        viewModel.getRandomWordsToWrite()
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 25)
        self.canvasView.contentSize = CGSize(width: 500, height: getRect().height / 3)
        self.canvasView.drawingPolicy = .anyInput

        if practice.practiceType == .deleteWord {
          animateSwipeIndicator()
        }
      })

      .onChange(of: viewModel.currentNumberGuessingIndex) { newIndex in
        if !viewModel.guessTheNumberPracticeDone {
          hapticEngine.playMorseCode(viewModel.actualNumberMorse)
        }
      }
      .onChange(of: viewModel.writtenWord) { newVal in
        print("new word: \(newVal)")
      }
      .onDisappear {
        viewModel.currentNumberGuessingIndex = 0
        viewModel.currentDeletingWordsIndex = 0
        viewModel.writingWordsIndex = 0
      }
    }
  @ViewBuilder func topSection() -> some View {
    HStack {
      Button(action: {
        dismiss()
      }) {
        Image(systemName: "xmark")
          .foregroundStyle(.gray)
          .font(.title3)
      }.padding(.leading)
      Spacer()
      Text(practice.title)
        .foregroundStyle(Color("textColor"))
        .font(.title3)
        .fontWeight(.bold)
      Spacer()
      Button(action: {
        dismiss()
      }) {
        Text("Done")
          .foregroundStyle(Color("accentColor"))
          .font(.title3)
          .fontWeight(.semibold)
      }.padding(.trailing)
    }
  }

  //MARK: - Guess the number
  @ViewBuilder func guessTheNumber() -> some View {
    ZStack {

      VStack(alignment: .center) {
        if !viewModel.guessTheNumberPracticeDone {
          VStack {
            HStack {
              Text("Your guessed number")
                .foregroundStyle(.gray)
                .font(.title2)
            }
            HStack {
              if viewModel.guessedNumber == nil {
                Text("0")
                  .foregroundStyle(Color("textColor").opacity(0.4))
                  .font(.system(size: 80))
                  .fontWeight(.bold)
              } else {
                Text(String(viewModel.guessedNumber!))
                  .foregroundStyle(Color("textColor"))
                  .font(.system(size: 80))
                  .fontWeight(.bold)
              }
            }
            HStack {
              MorseTextView(text: viewModel.guessedNumberMorse, showEditingIndicator: false, focused: false, maxCharacter: 100)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(viewModel.guessedNumber == nil ? Color.gray : Color("accentColor"))
            }
          }.padding(.vertical)
          VStack {
            HStack {
              Text("The actual number")
                .foregroundStyle(.gray)
                .font(.title2)
            }
            HStack {
              HStack {
                if viewModel.showActualNumber {
                  Text(String(viewModel.actualNumber))
                    .foregroundStyle(viewModel.showActualNumber ? Color("textColor") : Color("textColor").opacity(0.4))
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                } else {
                  Text("0")
                    .foregroundStyle(Color("textColor").opacity(0.4))
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                }
              }
            }
            HStack {
              MorseTextView(text: viewModel.actualNumberMorse, showEditingIndicator: false, focused: false, maxCharacter: 100)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(viewModel.showActualNumber ? Color("accentColor") : Color.gray)
            }
          }
        } else {
          HStack {
            congrats()
          }
        }
        //Pencilkit canvas
        VStack {
          if viewModel.guessTheNumberPracticeDone == false {
            ZStack {
              PKCanvasRepresentation(canvasView: $canvasView).frame(maxWidth: 400, maxHeight: getRect().height / 3)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                  RoundedRectangle(cornerRadius: 20).stroke(getStrokeColor(), lineWidth: 4)
                )
                .overlay(
                  HStack {
                    if canvasEmpty {
                      /*Text("\(Image(systemName: "hand.draw")) Sketch down the number here")
                       .foregroundStyle(.gray)
                       .font(.title3)*/
                    }
                  }, alignment: .center
                )
                .overlay(
                  HStack {
                    Button(action: {
                      hapticEngine.playMorseCode(viewModel.actualNumberMorse)
                    }) {
                      Image(systemName: "speaker.wave.3")
                        .foregroundStyle(Color("accentColor"))
                        .font(.title)
                        .fontWeight(.semibold)

                    }.padding(.leading)
                    Spacer()
                    Button(action: {
                      canvasView.drawing = PKDrawing()
                    }) {
                      Image(systemName: "trash")
                        .foregroundStyle(.red)
                        .font(.title)
                        .fontWeight(.semibold)
                    }.padding(.trailing)
                  }.padding(.top), alignment: .top
                )
            }
          }

          HStack {
            if !viewModel.guessTheNumberPracticeDone {
              HStack {
                Button(action: {
                  hapticEngine.playMorseCode(viewModel.actualNumberMorse)
                }) {
                  HStack {
                    Image(systemName: "speaker.wave.3")
                    Text("Listen again")
                  }
                    .font(.headline)
                    .frame(maxWidth: 250)
                }.tint(Color("accentColor"))
                  .controlSize(.large)
                  .buttonStyle(.bordered)
                Button(action: {
                  let image = preprocessImage()
                  inputImage = image
                  viewModel.predictImage(image: image)
                  viewModel.checkGuess()
                }) {
                  Text("Check")
                    .font(.headline)
                    .frame(maxWidth: 250)
                }.tint(Color("accentColor"))
                  .controlSize(.large)
                  .buttonStyle(.borderedProminent)
                if viewModel.rightGuess {
                  Button(action: {
                    canvasView.drawing = PKDrawing()
                    viewModel.nextNumber()
                  }) {
                    Image(systemName: "chevron.right")
                      .font(.headline)
                      .frame(maxWidth: 20)
                  }.tint(Color("accentColor"))
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                }
              }
            } else {
              Button(action: {
                guessTheNumberDone = true
                dismiss()
              }) {
                Text("Finish practice")
                  .font(.headline)
                  .frame(maxWidth: getRect().width / 2)
              }.tint(Color("accentColor"))
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
          }.padding().padding(.bottom)
        }
      }
    }
  }
  @ViewBuilder func guessTheNumberInstructions() -> some View {

  }
  //MARK: Deleting words(and sentences)
  @ViewBuilder func deletingWords() -> some View {
    ZStack {
      Color("BG").ignoresSafeArea(.all, edges: .all)
      VStack(alignment: .center) {
        Spacer()
        VStack {
          HStack {
            if viewModel.currentDeletingWordsIndex == 0 {
              deletingGesturesRecap()
            }
          }
          Spacer()
          HStack {
            if viewModel.deletingPracticeDone == false {
              Text(viewModel.deletingWordsInstructions)
                .foregroundStyle(.gray)
                .font(.title)
            }
          }
          HStack {
            if viewModel.deletingPracticeDone {
             congrats()
            } else {
              if !viewModel.nowDeletingSentences {
                VStack(alignment: .center) {
                  Text(viewModel.currentWord)
                    .foregroundStyle(Color("textColor"))
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                  MorseTextView(text: viewModel.currentWordMorse, showEditingIndicator: true, focused: true, maxCharacter: 150).foregroundStyle(Color("accentColor")).fontWeight(.semibold).font(.system(size: 60))
                }
              } else {
                VStack(alignment: .center) {
                  Text(viewModel.currentSentence)
                    .foregroundStyle(Color("textColor"))
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                  MorseTextView(text: viewModel.currentSentenceMorse, showEditingIndicator: true, focused: true, maxCharacter: 150).foregroundStyle(Color("accentColor")).fontWeight(.semibold).font(.system(size: 60))
                }
              }
            }
          }.overlay(
            ZStack {
              if viewModel.currentDeletingWordsIndex == 0 {
                swipeGestureIndicator()
              }
            }.padding(.top, 30).padding(.leading, 30), alignment: .bottomTrailing
          )
          HStack {
            if viewModel.deletingPracticeDone {
              Button(action: {
                deletingWordDone = true
                dismiss()
              }) {
                Text("Finish practice")
                  .font(.headline)
                  .frame(maxWidth: 300)
              }.tint(Color("accentColor"))
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
          }
          Spacer()
        }.padding()

        Spacer()
      }
    }.gesture(
      DragGesture(minimumDistance: 20, coordinateSpace: .local).onEnded { value in
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height
        if abs(horizontalAmount) > abs(verticalAmount) {
          if horizontalAmount < 0 {
            if !viewModel.deletingPracticeDone {
              if !viewModel.nowDeletingSentences {
                withAnimation(.easeOut(duration: 0.1)) {
                  viewModel.randomWords[viewModel.currentDeletingWordsIndex].removeLast()
                  if viewModel.currentWord.isEmpty {
                    viewModel.currentDeletingWordsIndex += 1
                  }
                }
              } else {
                withAnimation(.easeOut(duration: 0.1)) {
                  viewModel.randomSentences[viewModel.currentDeletingSentencesIndex].removeLast()
                  if viewModel.currentSentence.isEmpty {
                    viewModel.currentDeletingSentencesIndex += 1
                  }
                }
              }
            }
          }
        }
      }
    )
  }
  @ViewBuilder func deletingGesturesRecap() -> some View {
    HStack {
      Text("\(Text("Swipe left").foregroundColor(Color("accentColor"))) to delete one character")
        .foregroundStyle(Color("textColor"))
        .font(.largeTitle)
        .fontWeight(.semibold)

    }
  }
  @ViewBuilder func swipeGestureIndicator() -> some View {
    ZStack {
      VStack {
        HStack {
          Image(systemName: "hand.point.up.left.fill")
            .font(.largeTitle)
            .foregroundStyle(Color("accentColor"))
            .fontWeight(.bold)
        }

      }.offset(x: gestureIndicatorXOffset)
    }
  }
  //MARK: - Writing a given word with morse
  @ViewBuilder func writingWords() -> some View {
    ZStack {
      Color("BG").ignoresSafeArea(.all, edges: .all)
      VStack(alignment: .center) {
        VStack {
          if viewModel.practiceDone == false {
            VStack {
              HStack {
                Text("Write the following word")
                  .foregroundStyle(.gray)
                  .font(.title)
              }
              HStack {
                Text(viewModel.displayWord)
                  .font(.system(size: 80))
                  .fontWeight(.bold)
              }.frame(maxWidth: 300)
              HStack {
                MorseTextView(text: viewModel.currentWordToWriteMorse, showEditingIndicator: false, focused: false, maxCharacter: 100)
                  .foregroundStyle(Color("accentColor"))
                  .font(.title)
                  .fontWeight(.bold)
                /*.padding(.horizontal)
                 .padding(.vertical)
                 .overlay(
                 Button(action: {
                 withAnimation(.easeInOut) {
                 viewModel.hideMorse.toggle()
                 }
                 }) {
                 Image(systemName: "eye.slash")
                 .foregroundStyle(Color("accentColor"))
                 .font(.headline)
                 }.padding(.leading), alignment: .topTrailing
                 )*/
              }
              HStack {
                Button(action: {
                  hapticEngine.playMorseCode(viewModel.currentWordToWriteMorse)
                }) {
                  HStack {
                    Image(systemName: "speaker.wave.3")
                    Text("Listen")
                  }.font(.headline)
                }.tint(Color("accentColor"))
                  .controlSize(.large)
                  .buttonStyle(.bordered)
              }
              //Morse Canvas
              HStack {
                MorseCanvasView(morse: $viewModel.writtenMorse, interacting: $viewModel.interactingWithMorseCanvas, focused: .constant(true), reactToPinch: true, showMorse: true, bg: .white, speechRecognizer: SpeechState(), config: SpeechDetection())
                  .clipShape(RoundedRectangle(cornerRadius: 50))
                  .frame(maxWidth: 400, maxHeight: getRect().height / 3)
              }.padding()
            }
          } else {
            congrats()
          }
          HStack {
            if viewModel.showNextButton {
              Button(action: {
                withAnimation(.spring()) {
                  viewModel.writtenMorse = ""
                  viewModel.writingWordsIndex += 1
                }
              }) {
                Text("Next word")
                  .font(.headline)
                  .frame(maxWidth: 300)
              }.tint(Color("accentColor"))
                .controlSize(.large)
                .buttonStyle(.bordered)
            }
            if viewModel.practiceDone {
              Button(action: {
                writeAWordDone = true
                dismiss()
              }) {
                Text("Finish practice")
                  .font(.headline)
                  .frame(maxWidth: 300)
              }.tint(Color("accentColor"))
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
          }
        }
      }
    }
  }
  func preprocessImage() -> UIImage {
      var replacingStrokes: [PKStroke] = []

      let circleRadius: CGFloat = 1.0
    let margin: CGFloat = 0.1

      let topLeftPoint = CGPoint(x: margin, y: margin)
    let topRightPoint = CGPoint(x: canvasView.drawing.bounds.maxX - margin, y: margin)
      let bottomLeftPoint = CGPoint(x: margin, y: canvasView.bounds.maxY - margin)
      let bottomRightPoint = CGPoint(x: canvasView.bounds.maxX - margin, y: canvasView.bounds.maxY - margin)

      let topLeftCircle = createCircleStroke(at: topLeftPoint, with: circleRadius)
      let topRightCircle = createCircleStroke(at: topRightPoint, with: circleRadius)
      let bottomLeftCircle = createCircleStroke(at: bottomLeftPoint, with: circleRadius)
      let bottomRightCircle = createCircleStroke(at: bottomRightPoint, with: circleRadius)
    canvasView.drawing.strokes.append(contentsOf: [bottomLeftCircle, bottomRightCircle, topLeftCircle, topRightCircle])
    var tempPKDrawing = canvasView.drawing
    var tempStrokes = tempPKDrawing.strokes

      tempStrokes.forEach { stroke in
          var newStroke = stroke
          newStroke.ink.color = .white
          replacingStrokes.append(newStroke)
      }

      let newDrawing = PKDrawing(strokes: replacingStrokes)
      let image = newDrawing.image(from: newDrawing.bounds, scale: 150.0)

      return image
  }

  func createCircleStroke(at center: CGPoint, with radius: CGFloat) -> PKStroke {
      var circleStroke = PKStroke(ink: .init(.pen), path: PKStrokePath())
      let bezierPath = UIBezierPath(
          arcCenter: center,
          radius: radius,
          startAngle: 0,
          endAngle: CGFloat(2 * Double.pi),
          clockwise: true
      )
      var pathPoints = bezierPath.generatePathPoints().map { pathpoint in
        PKStrokePoint(location: pathpoint.first!, timeOffset: 0, size: .init(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: 0)
      }
      var strokePath = PKStrokePath(controlPoints: pathPoints, creationDate: Date())
      circleStroke.path = strokePath
    circleStroke.ink.color = .white
      return circleStroke
  }
  private func getStrokeColor() -> Color {
    if viewModel.guessedNumber == nil {
      return .gray
    } else {
      return viewModel.rightGuess ? Color("accentColor") : Color.red
    }
  }
  private func animateSwipeIndicator() {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      withAnimation(.easeInOut(duration: 1)) {
        if gestureIndicatorXOffset == 0 {
          gestureIndicatorXOffset = -350
        } else {
          withAnimation(.spring(duration: 0)) {
            gestureIndicatorXOffset = 0
          }
        }
      }
    }
  }
  @ViewBuilder func congrats() -> some View {
    HStack {
      Text("Congrats you have finished!")
        .foregroundStyle(Color("textColor"))
        .font(.system(size: 80))
        .fontWeight(.bold)
        .confettiCannon(counter: $viewModel.confettiCount, num: 120)
        .onAppear() {
          viewModel.confettiCount += 40
        }
    }
  }
}

#Preview {
  PracticeView(practice: PracticeModel(title: "", description: "", coverImage: "", practiceType: .deleteWord, level: .easy))
}
#Preview {
  PracticeView(practice: PracticeModel(title: "", description: "", coverImage: "", practiceType: .writeGivenWord, level: .easy))
}
