//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import SwiftUI

struct PracticePreviewView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.refresh) var refresh: RefreshAction?

  @State private var showPratice: Bool = false
  @Binding var index: Int

  var practice: PracticeModel {
    return availablePractices[index]
  }
    var body: some View {
      NavigationStack {
        ZStack {
          VStack {
            ScrollView(.vertical, showsIndicators: false) {
              HStack {
                ZStack {
                  Image("\(practice.coverImage)Wide")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 400)
                  
                  
                }
              }
              
              VStack {
                
                HStack {
                  Text(practice.title)
                    .foregroundStyle(Color("textColor"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                  Spacer()
                }.padding(.top)
                HStack {
                  Text(practice.description)
                    .foregroundStyle(.gray)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                  Spacer()
                }
                HStack {
                  Text("Level")
                    .foregroundStyle(Color("textColor"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.leading)
                  Spacer()
                }.padding(.vertical)
                HStack {
                  Text(practice.level.description)
                    .font(.title3)
                    .foregroundStyle(practice.level.color)
                    .fontWeight(.bold)
                    .padding()
                    .background {
                      RoundedRectangle(cornerRadius: 12)
                        .fill(practice.level.color.opacity(0.2))
                    }
                    .padding(.leading)
                  Spacer()
                }
                instructionsView.padding(.vertical)
              }
            }
            Spacer()
            HStack {
              Button(action: {
                print("showing practice view")
                showPratice = true
              }) {
                Text("Start Practice")
                  .font(.headline)
                  .frame(maxWidth: getRect().width / 2)
              }.tint(Color("accentColor"))
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }.padding(.bottom)
          }
        }
      }.fullScreenCover(isPresented: $showPratice, content: {
        PracticeView(practice: practice)
      })
      .onAppear(perform: {
        print("showing preview for index: \(index)")
      })
    }

  var instructionsView: some View {
    VStack {
      HStack {
        Text("Before starting")
          .foregroundStyle(Color("textColor"))
          .font(.title2)
          .fontWeight(.semibold)
          .padding(.leading)
        Spacer()
      }
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Image(systemName: "hand.wave")
          Text("Place on hand on the back of the device")
          Spacer()
        }.padding(.leading).foregroundStyle(.secondary)
        HStack {
          Image(systemName: "speaker.wave.3")
          Text("Turn up the volume")
          Spacer()
        }.padding(.leading).foregroundStyle(.secondary)
      }.padding(.top, 3)
    }
  }
}
#Preview {
  PracticePreviewView(index: .constant(0))
}
