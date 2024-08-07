//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import SwiftUI
import AVFoundation

struct GestureExplanationSheet: View {
  @Environment(\.dismiss) var dismiss

  @State private var readOutMorse: Bool = false

  @State private var showTheoReadOutWarning: Bool = false

  let speak = Speak()

  @Binding var index: Int
    var body: some View {
      VStack {
        HStack {
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark")
              .font(.title3)
              .fontWeight(.semibold)
              .foregroundStyle(.gray)
          }
          Spacer()

        }
        HStack {
          Image(gestureRecaps[index].icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 100)

        }
        VStack(alignment: .center) {
          Text(gestureRecaps[index].title)
            .font(.title)
            .fontWeight(.bold)
          Text(gestureRecaps[index].description).theoReadOut(text: gestureRecaps[index].description, play: $readOutMorse)
            .font(.title3)
            .foregroundStyle(.gray)
            .padding(.vertical, 4)
            .multilineTextAlignment(.center)

        }
        HStack {
          Button(action: {
            speak.sayThis(gestureRecaps[index].title)
            speak.sayThis(gestureRecaps[index].description)
          }) {
            HStack {
              Image(systemName: "speaker.wave.3")
              Text("Speak out loud")
            }.font(.headline)
              .frame(maxWidth: 200)
          }.tint(Color("accentColor"))
            .controlSize(.regular)
            .buttonStyle(.bordered)
            .clipShape(RoundedRectangle(cornerRadius: 20))
          Button(action: {
            if readOutMorse == false {
              showTheoReadOutWarning = true
            } else {
              readOutMorse = false
            }
          }) {
            HStack {
              if readOutMorse == false {
                Image("LogoSVG")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(maxWidth: 25)
                Text("Read morse")
              } else {
                Circle().fill(.red).frame(width: 15, height: 15)
                Text("Stop")
              }
            }.font(.headline).frame(maxWidth: 200)
          }.tint(readOutMorse ? Color.red : Color("accentColor"))
            .controlSize(.regular)
            .buttonStyle(.bordered)
            .clipShape(RoundedRectangle(cornerRadius: 20))

        }.padding()
        Spacer()
      }.padding()
        .alert("Warning", isPresented: $showTheoReadOutWarning) {
          HStack {
            Button(action: {
              showTheoReadOutWarning = false
            }) {
              Text("Cancel")
            }
            Button(action: {
              readOutMorse.toggle()
            }) {
              Text("OK")
            }
          }
        } message: {
          Text("This will start a long sequence of morse code being played out.")
        }
    }
}

#Preview {
  GestureExplanationSheet(index: .constant(0))
}
