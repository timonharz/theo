//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 11.02.24.
//

import SwiftUI
import AVFoundation

struct TranslateView: View, KeyboardReadable {
  @ObservedObject var viewModel: TranslateViewModel
  @ObservedObject var appState: AppState
  @StateObject var speechState = SpeechState()

  private let speak = Speak()
  private let hapticEngine = HapticEngine.shared

  @State var isYouTextFieldFocused: Bool = false
  @State var isTheyTextFieldFocused: Bool = false
  @FocusState private var isYouTextField: Bool
  @FocusState private var isTheyTextField: Bool
  @State private var isTextFieldCanvasFocused: Bool = false
  @State private var isKeyboardVisible = false

  var activeListeningOn: Bool {
    return appState.activeListeningOn && !isYouTextFieldFocused
  }

  var shouldHideSpeakerSection: Bool {
    return isKeyboardVisible && isTheyTextField
  }
  var shouldHideListenerSection: Bool {
    return isKeyboardVisible && isYouTextField
  }

  let config = SpeechDetection(monitoredSounds: [
    SoundIdentifier(labelName: "speech"),
    SoundIdentifier(labelName: "whispering"),
    SoundIdentifier(labelName: "clapping")
])

  var body: some View {
    NavigationStack {
      ZStack {
        if viewModel.focusCanvas {
          Color.black.ignoresSafeArea(.all, edges: .all).transition(.move(edge: .bottom))
        } else {
          Color("BG").ignoresSafeArea(.all, edges: .all).transition(.move(edge: .top))
        }
          VStack {
              VStack {
                if viewModel.focusCanvas {
                    editView()
                } else {
                    chatView
                }
              }.onChange(of: viewModel.soundDetected) { newValue in
                if newValue == false {
                  print("sound detected state has changed")
                }
                }

          }.padding().navigationTitle("Chat").navigationBarHidden(viewModel.focusCanvas).navigationBarTitleDisplayMode((viewModel.speakerTextFieldMorse.count > 250 || viewModel.listenerTextFieldMorse.count > 250 || shouldHideSpeakerSection || shouldHideListenerSection) ? .inline : .large)
      }.fullScreenCover(isPresented: $viewModel.showTranscribeView, content: {
        TranscribeView(text: $viewModel.listenerTextFieldText, presented: $viewModel.showTranscribeView).onDisappear {
          speechState.restartDetection(config: config)
        }
      })
      .fullScreenCover(isPresented: $viewModel.showCameraView, content: {
        TextRecognitionView(translateViewModel: viewModel).ignoresSafeArea(.all, edges: .all).onDisappear {
          speechState.restartDetection(config: config)
        }
                })
      .sheet(isPresented: $viewModel.showSettings, content: {
        SettingsView(appState: appState).onAppear(perform: {
          speechState.stopSession()
        })
        .onDisappear {
          speechState.restartDetection(config: config)
        }
      })

      .toolbar {
        ToolbarItemGroup(placement: .topBarTrailing) {
          ActiveListeningIndicator(appState: appState, activeListeningOn: activeListeningOn)
          HStack {
            Button(action: {
              speechState.stopSession()
              viewModel.showCameraView = true
            }) {
              Image(systemName: "camera")
            }
          }
          Button(action: {
            viewModel.showSettings = true
          }) {
            Image(systemName: "gearshape")
              .font(.headline)
              .fontWeight(.semibold)
              .padding(5)
              .background {
                Circle().fill(.white)
              }.padding(.trailing)
          }
        }
      }
    }.onReceive(speechState.$detectionStates) { detectionStates in
      print("running onReceive")
      // Check if one of the monitored sounds has been detected
      guard !viewModel.showCameraView && appState.activeListeningOn else { return }
        for (sound, state) in detectionStates {
          if state.isDetected {
                      // Perform your action here
                      print("Detected sound: \(sound.labelName)")
                      if !viewModel.soundDetected && !viewModel.lastSheetPresentationState {
                           viewModel.soundDetected = true
                          viewModel.showTranscribeView = true
                          viewModel.lastSheetPresentationState = true
                        speechState.stopSession()
                          print("breaking detection loop")
                          break // Exit the loop since actions are performed
                      } else {
                          viewModel.lastSheetPresentationState = false
                      }
                  }
        }

  }
    .sheet(isPresented: $viewModel.showTokenizeSheet, content: {
      TokenizeView(text: $viewModel.listenerTextFieldText).onDisappear {
        speechState.restartDetection(config: config)
      }
    })
    .onAppear {
        speechState.restartDetection(config: config)
    }
    .onDisappear() {
     speechState.stopSession()
    }
    .onChange(of: viewModel.speakerTextFieldText) { newValue in
      withAnimation {
        viewModel.speakerTextFieldMorse = viewModel.morseCode.encodeToMorse(newValue)

        
      }
      isYouTextFieldFocused = true
      isTheyTextFieldFocused = false
      
    }
    .onChange(of: viewModel.listenerTextFieldText) { newValue in
      withAnimation {
        viewModel.listenerTextFieldMorse = viewModel.morseCode.encodeToMorse(newValue)
      }
      isTheyTextFieldFocused = true
      isYouTextFieldFocused = false

    }

    .onChange(of: isYouTextField) { newValue in
      if newValue {
        isYouTextFieldFocused = true
        isTheyTextFieldFocused = false
      } else {
        isYouTextFieldFocused = false
        
      }
      viewModel.getLanguages()
    }
    .onChange(of: isTheyTextField) { newValue in
      if newValue {
        isTheyTextFieldFocused = true
        isYouTextFieldFocused = false
      }  else {
        isTheyTextFieldFocused = false
      }
      viewModel.getLanguages()
    }
    .onChange(of: isYouTextFieldFocused) { newValue in
      if newValue {
        print("stopping session in on change")
        speechState.stopSession()
      } else {
        if !isTheyTextFieldFocused {
          speechState.restartDetection(config: config)
        }
        //reset states otherwise the sheet might not open properly
        viewModel.showTranscribeView = false
        viewModel.soundDetected = false
      }
    }
    .onChange(of: isTheyTextFieldFocused) { newValue in
      if newValue {
        print("stopping session")
        speechState.stopSession()
      } else {
        if !isYouTextFieldFocused {
          speechState.restartDetection(config: config)
        }
        //reset states otherwise the sheet might not open properly
        viewModel.showTranscribeView = false
        viewModel.soundDetected = false
      }
      }
    .onChange(of: viewModel.speakerTextFieldMorse) { newValue in
        viewModel.speakerTextFieldText = viewModel.morseCode.decodeFromMorse(viewModel.speakerTextFieldMorse)
    }

    .overlay(
      HStack {
        Button(action: {
          withAnimation(.spring()) {
            viewModel.focusCanvas.toggle()
          }
        }) {
          Image(systemName: viewModel.focusCanvas ? "arrow.down" : "arrow.up")
            .font(.headline)
            .foregroundStyle(Color("accentColor"))
            .padding(6)
            .background {
              Circle().fill(Color("accentColor").opacity(0.1))
            }
        }
      }.padding(.leading),alignment: .topLeading
    )
    .simultaneousGesture(
      DragGesture(minimumDistance: 20, coordinateSpace: .local).onEnded { value in
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height
        if verticalAmount < 0 {
          withAnimation(.easeIn(duration: 0.12)) {
            viewModel.focusCanvas = true

          }
        }
        if verticalAmount > 200 {
          withAnimation(.easeOut(duration: 0.12)) {
            viewModel.focusCanvas = false

          }
        }

      })
      /*LongPressGesture(minimumDuration: 2).onEnded { val in
        withAnimation(.easeInOut) {
          viewModel.focusCanvas.toggle()
        }
      }
    )*/
    .modifier(ShowCaseRoot(showHighlights: true, onFinished: {
      viewModel.showCasingDone = false
    }))


    }
  @ViewBuilder func chatSection() -> some View {
    VStack(spacing: 20) {
      if !shouldHideSpeakerSection {
        speakerSection().transition(.move(edge: .bottom)).animation(.easeInOut(duration: 0.3))
      }
      if !shouldHideListenerSection {
        listenerSection().transition(.move(edge: .top)).animation(.easeIn(duration: 0.3))
      }

    }.padding()
  }
  @ViewBuilder func hintSection() -> some View {
    HStack {
      if !viewModel.focusCanvas {
        VStack(alignment: .center) {
          if appState.activeListeningOn {
            Text("Theo is actively listening to the sound around you, just start talking to translate.")
          }
          Text("Swipe up or shake to switch to simple chat.")
        }
      } else {
        Text("Swipe up to start transcribing.")
      }
    }.foregroundStyle(.gray)
      .multilineTextAlignment(.center)
  }
  @ViewBuilder func speakerSection() -> some View {
    VStack {
      HStack {
        Button(action: {
          isTheyTextFieldFocused = false
          isYouTextFieldFocused = true
          speak.sayThis(viewModel.speakerTextFieldText)

        }) {
          Image(systemName: "speaker.wave.3")
            .foregroundStyle(Color("accentColor"))
            .font(.headline)
            .fontWeight(.bold)
        }
        if viewModel.showSpeakerLanguage {
          Text(viewModel.speakerLanguage)
            .foregroundStyle(.gray)
            .font(.headline)
            .fontWeight(.medium)
        }
        Spacer()
          Text(viewModel.currentSpeaker.description)
            .foregroundStyle(.gray)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.leading)
      }
      HStack {
        TextField("Enter your text...", text: $viewModel.speakerTextFieldText)
          .font(.title)
          .foregroundStyle(Color("accentColor"))
          .multilineTextAlignment(.trailing)
          .padding(.vertical)
          .focused($isYouTextField)
          .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                          print("Is keyboard visible? ", newIsKeyboardVisible)
            withAnimation(.spring()) {
              isKeyboardVisible = newIsKeyboardVisible
            }
                      }

      }
      if !isTheyTextField && !isTheyTextFieldFocused {
        Divider()
        Spacer()
        VStack(alignment: .trailing) {

          MorseCanvasView(morse: $viewModel.speakerTextFieldMorse, interacting: $isTextFieldCanvasFocused, focused: $isYouTextFieldFocused, reactToPinch: true, showMorse: true, bg: .white, speechRecognizer: speechState, config: config).frame(maxHeight: .infinity)

        }
        Spacer()
      }
    }.padding().background {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(.white))
        .overlay(
          ZStack {
            RoundedRectangle(cornerRadius: 12).stroke(Color("accentColor"), lineWidth: isYouTextFieldFocused ? 3 : 0)
            RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 0.5)
          }
        )
    }
  }
  @ViewBuilder func listenerSection() -> some View {
    VStack {
      HStack {
        Text(viewModel.currentListener.description)
          .foregroundStyle(.gray)
          .font(.title3)
          .fontWeight(.semibold)
          .padding(.leading)
        Spacer()
        HStack {
          if viewModel.showListenerLanguage {
            Text(viewModel.listenerLanguage)
              .foregroundStyle(.gray)
              .font(.headline)
              .fontWeight(.medium)
          }
          if viewModel.showTokenizeOption {
            Button(action: {
              speechState.stopSession()
              viewModel.showTokenizeSheet = true
            }) {
              Image(systemName: "textformat.alt")
                .foregroundStyle(Color("accentColor"))
                .font(.headline)
            }
          }
          Button(action: {
            viewModel.showTranscribeView = true
          }) {
            Image(systemName: "mic")
              .foregroundStyle(Color("accentColor"))
              .font(.headline)
          }.padding(.horizontal, 10)
          Button(action: {
            isYouTextFieldFocused = false
            isTheyTextFieldFocused = true
            speak.sayThis(viewModel.listenerTextFieldText)

          }) {
            Image(systemName: "speaker.wave.3")
              .foregroundStyle(Color("accentColor"))
              .font(.headline)
          }
        }
      }
      TextField("I am listening...", text: $viewModel.listenerTextFieldText)
        .font(.title)
        .foregroundStyle(Color("accentColor"))
        .padding(.leading)
        .padding(.vertical)
        .focused($isTheyTextField)
      if !isYouTextFieldFocused {
        HStack {
          MorseTextView(text: viewModel.listenerTextFieldMorse, showEditingIndicator: false, focused: false, maxCharacter: 200)
            .foregroundStyle(Color("accentColor"))
            .fontWeight(.semibold)
            .padding(.leading)
          Spacer()
        }.frame(maxHeight: .infinity)
        Spacer()
      }
    }.padding().background {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color(.white))
        .overlay(
          ZStack {
            RoundedRectangle(cornerRadius: 12).stroke(Color("accentColor"), lineWidth: isTheyTextFieldFocused ? 3 : 0)
            RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 0.5)
          }
            )
    }
  }
  @ViewBuilder func chooseSpeaker() -> some View {
    HStack {
      HStack {
        VStack {
          Text(viewModel.currentSpeaker.description)
            .foregroundStyle(Color("textColor"))
            .font(.headline)
            .fontWeight(.semibold)
            .transition(.opacity)
          if viewModel.showSpeakerLanguage {
            Text(viewModel.speakerLanguage)
              .foregroundStyle(.gray)
              .font(.caption)
          }
        }
      }.padding().frame(width: 100).background {
        RoundedRectangle(cornerRadius: 12)
          .fill(.white)
          .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 0.3)
          )
      }
      HStack {
        Button(action: {
          withAnimation(.easeInOut) {
            if viewModel.currentSpeaker == .you {
              viewModel.currentSpeaker = .they
              viewModel.currentListener = .you
            } else {
              viewModel.currentSpeaker = .you
              viewModel.currentListener = .they
            }
          }
        }) {
          Image(systemName: "arrow.left.arrow.right")
            .foregroundStyle(Color("accentColor"))
            .font(.headline)
            .fontWeight(.semibold)
        }
      }.padding().background {
        RoundedRectangle(cornerRadius: 12)
          .fill(.white) .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 0.3)
          )
      }
      HStack {
        VStack {
          Text(viewModel.currentListener.description)
            .foregroundStyle(Color("textColor"))
            .font(.headline)
            .fontWeight(.semibold)
            .transition(.opacity)
          if viewModel.showListenerLanguage {
            Text(viewModel.listenerLanguage)
              .foregroundStyle(.gray)
              .font(.caption)
          }
        }

      }.padding().frame(width: 100).background {
        RoundedRectangle(cornerRadius: 12)
          .fill(.white) .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 0.3)
          )
      }
    }
  }
  @ViewBuilder func editView() -> some View {
    ZStack {
      MorseCanvasView(morse: $viewModel.speakerTextFieldMorse, interacting: $isTextFieldCanvasFocused, focused: .constant(false), reactToPinch: false, showMorse: false, bg: .black, speechRecognizer: speechState, config: config).frame(width: getRect().width,height: getRect().height).contentShape(Rectangle()).allowsHitTesting(true)
      VStack {
        //MARK: - Speaker
        VStack {
          HStack {
            Spacer()
            Text(viewModel.currentSpeaker.description)
              .foregroundStyle(.gray)
              .font(.title)
              .padding(.trailing)
          }.padding(.top)
          HStack {
            Spacer()
            if viewModel.speakerTextFieldText.isEmpty {
              Text("Start morse editing")
                .foregroundStyle(.gray)
                .font(.system(size: 60))
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
            } else {
              Text(viewModel.speakerTextFieldText)
                .foregroundStyle(.white)
                .font(.system(size: 60))
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
            }
          }.padding(.trailing)
          HStack {
            Spacer()
            MorseTextView(text: viewModel.speakerTextFieldMorse, showEditingIndicator: false, focused: isYouTextFieldFocused, maxCharacter: 80).foregroundStyle(Color("accentColor"))
              .font(.system(size: 40))
              .multilineTextAlignment(.trailing)

          }.padding(.trailing)
        }.padding(.top, getSafeArea().top * 2)
        //MARK: - Listener
        VStack {
          HStack {
            Text(viewModel.currentListener.description)
              .foregroundStyle(.gray)
              .font(.title)
              .padding(.leading)
            Spacer()
          }
          HStack {
            if viewModel.listenerTextFieldText.isEmpty {
              Text("I am listening...")
                .foregroundStyle(.gray)
                .font(.system(size: 60))
                .fontWeight(.bold)
                .padding(.leading)
            } else {
              Text(viewModel.listenerTextFieldText)
                .foregroundStyle(.white)
                .font(.system(size: 60))
                .fontWeight(.bold)
                .padding(.leading)
            }

            Spacer()
          }
          HStack {
            MorseTextView(text: viewModel.listenerTextFieldMorse, showEditingIndicator: false, focused: false, maxCharacter: 80)
              .foregroundStyle(Color("accentColor"))
              .font(.system(size: 40))
              .multilineTextAlignment(.leading)
              .padding(.leading)
            Spacer()
          }
        }
        Spacer()
        hintSection().padding(.bottom, 80)
        /*HStack {
          if viewModel.speakerTextFieldMorse.isEmpty {
            Text("\(Image(systemName: "arrow.down")) swipe down to leave")
              .foregroundStyle(Color(.systemGray).opacity(0.6))
              .font(.system(size: 18))
          }
        }.padding(.bottom, getSafeArea().bottom * 7)*/
      }
    }.simultaneousGesture(
      DragGesture(minimumDistance: 20, coordinateSpace: .local).onEnded { value in
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height
        print("vertical amount: \(verticalAmount)")
        if verticalAmount > 200 {
          withAnimation(.easeOut(duration: 0.12)) {
            viewModel.focusCanvas = false

          }
        } else if verticalAmount < -200 {
          viewModel.showTranscribeView = true
        }
      }
    )
    .simultaneousGesture(
      MagnificationGesture().onEnded { val in
        speechState.stopSession()
        if val > 1 {
          hapticEngine.playMorseCode(viewModel.listenerTextFieldMorse)
        } else if val < 1 {
          speak.sayThis(viewModel.speakerTextFieldText)
          hapticEngine.playMorseCode("  ")
        }
        speechState.restartDetection(config: config)
      }
    )
  }
  var chatView: some View {
    VStack {
      if !isKeyboardVisible && !isYouTextFieldFocused {
        chooseSpeaker()
      }
      chatSection()
      Spacer()
      hintSection().padding().padding(.bottom)
    }
  }

}
