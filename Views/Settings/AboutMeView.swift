//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 24.02.24.
//

import SwiftUI

struct AboutMeView: View {

  let morseCode = MorseCodeModel()
  let speak = Speak()

  var aboutMeTitle: String {
    return "Hi! - I'm Timon"
  }
  var aboutMeText: String {
    return "My name is Timon Harz, and I am 15 years old from Demmin, Germany. In January, I launched my first app called 'Oneboard'. I enjoy thinking up new and big ideas and then bring them to reality with Swift. I am convinced Theo can make a difference for a deafblind individual's communication. It allows them to replace impractical and ineffcient devices like a Telebraille with their iPhone or iPad, opening up a whole new world of independence for the deafblind community."
  }

  var aboutMeMorse: String {
    return morseCode.encodeToMorse(aboutMeText)
  }

  @State private var readOutMorse: Bool = false
  @State private var showWarning: Bool = false
    var body: some View {
      NavigationStack {
        VStack(alignment: .center) {
          HStack {
            Image("me")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: 250)
              .clipShape(Circle())
          }
          .overlay (
          HStack {
            Text("Hi! - I'm Timon")
              .foregroundStyle(Color("textColor"))
              .font(.largeTitle)
              .fontWeight(.bold)
          }, alignment: .bottom
          )
          HStack {
            Text(aboutMeText)
              .theoReadOut(text: aboutMeText, play: $readOutMorse)
              .font(.title3)
              .padding()
              .frame(maxWidth: getRect().width - 100)
              .multilineTextAlignment(.center)

          }
          HStack {
            Button(action: {
              speak.sayThis(aboutMeTitle)
              speak.sayThis(aboutMeText)
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
                showWarning = true
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
        }.navigationTitle("About").navigationBarTitleDisplayMode(.inline)
      }.alert("Warning", isPresented: $showWarning) {
        HStack {
          Button(action: {
            showWarning = false
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
    AboutMeView()
}
