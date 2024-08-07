//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 19.02.24.
//

import SwiftUI

struct TextRecognitionView: View {
    @StateObject var viewModel = TextRecogntionViewModel()

  @ObservedObject var translateViewModel: TranslateViewModel

  @Environment(\.dismiss) var dismiss

  @Namespace private var namespace

    var body: some View {
      ZStack {
        VStack {
          if viewModel.textRecognitionperformed {
            VStack {
              resultView()
              resultSheet().frame(maxHeight: 300)
            }.matchedGeometryEffect(id: "viewTransition", in: namespace)
          } else {
            cameraView().overlay(
              ZStack {
                if viewModel.isLoading {
                  loadingScreen()
                }
              }, alignment: .center
            )
            .matchedGeometryEffect(id: "viewTransition", in: namespace)
            .onAppear {
              viewModel.isLoading = false
            }
          }
        }
      }.onChange(of: viewModel.inputImage) { newValue in
        viewModel.recognizeText()
      }
    }
  @ViewBuilder func cameraView() -> some View {
    ZStack {
      TextRecognitionCameraView(didTakePicture: $viewModel.didTakePicture, viewModel: viewModel)
      VStack {
        HStack {
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark")
              .foregroundStyle(Color(.systemGray))
              .font(.title)
          }.padding(.leading)
          Spacer()
          Spacer()
        }.padding(.top)
        Spacer()
        Spacer()
      }

    }
  }
  @ViewBuilder func resultView() -> some View {
    ZStack {
      Color.black.ignoresSafeArea(.all, edges: .top)
      VStack {
        HStack {
          Button(action: {
            withAnimation {
              viewModel.isLoading = false
              viewModel.textRecognitionperformed = false
              viewModel.didTakePicture = false
              viewModel.inputImage = nil
            }
          }) {
            Text("Cancel")
              .foregroundStyle(Color.white)
              .font(.title3)
          }.padding(.leading)
          Spacer()
        }.padding(.top)
        Spacer()
        HStack {
          Image(uiImage: viewModel.inputImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: getRect().width - 100)
            .rotationEffect(.degrees(-90))
        }
        Spacer()
      }
    }
  }
  @ViewBuilder func resultSheet() -> some View {
    ZStack {
      Color.white.ignoresSafeArea(.all, edges: .bottom).clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 12))
      VStack {
        HStack {
          Text("\(Text(viewModel.resultTextLanguage).foregroundColor(Color("accentColor")).fontWeight(.semibold)) detected")
            .font(.title3)
            .foregroundStyle(.gray)
            .padding(.leading)
          Text("•").foregroundStyle(.gray).padding(.horizontal, 4)
          Button(action: {
            copyToClipboard(text: viewModel.recognizedText)
          }) {
            Text("Copy text")
              .foregroundStyle(.gray)
          }
          Spacer()
        }.padding(.top)
        Spacer()
        VStack(alignment: .leading) {
          ScrollView(.vertical, showsIndicators: false) {
            HStack {
              Text(viewModel.recognizedText)
                .foregroundStyle(Color("textColor"))
                .multilineTextAlignment(.leading)
                .padding(.leading)
              Spacer()
            }
          }
          Spacer()
        }
        Spacer()
        VStack(alignment: .leading, spacing: 20) {
          HStack {
            Button(action: {
              translateViewModel.speakerTextFieldText = viewModel.recognizedText
              dismiss()
            }) {
              HStack {
                Image(systemName: "doc.on.doc")
                Text("Copy to '\(translateViewModel.currentSpeaker.description)'")
              }.font(.title3)
                .fontWeight(.semibold)
            }.foregroundStyle(Color("accentColor"))
              .padding(.leading)
            Spacer()
          }
          HStack {
            Button(action: {
              translateViewModel.listenerTextFieldText = viewModel.recognizedText
              dismiss()
            }) {
              HStack {
                Image(systemName: "doc.on.doc")
                Text("Copy to '\(translateViewModel.currentListener.description)'")
              }
            }.foregroundStyle(.gray)
            Spacer()
          }.padding(.leading)
        }.padding(.bottom)
      }
    }
  }
  @ViewBuilder func loadingScreen() -> some View {
    ZStack {
      Color.black.opacity(0.8).ignoresSafeArea(.all, edges: .all)
      VStack {
        Spacer()
        VStack(alignment: .center) {
          ProgressView()
          Text("Performing Text Recognition")
            .foregroundStyle(.white)
        }
        Spacer()
      }
    }
  }
  func copyToClipboard(text: String) {
         let pasteboard = UIPasteboard.general
         pasteboard.string = text
     }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea(.all, edges: .all)
    TextRecognitionView(translateViewModel: TranslateViewModel())
  }
}
