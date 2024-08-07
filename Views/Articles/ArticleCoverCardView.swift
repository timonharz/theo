//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 17.02.24.
//

import SwiftUI

struct ArticleCoverCardView: View {
  @Binding var article: Article

  @State private var imageScale: CGFloat = 1.0
    var body: some View {
      ZStack {
        Image("\(article.coverImage)Vertical")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(imageScale)
          .frame(maxWidth: 200)
          .clipShape(RoundedRectangle(cornerRadius: 20))
          .onHover(perform: { hovering in
            print("hovering: \(hovering)")
            withAnimation(.spring()) {
              imageScale = 0.1
            }
          })
          .overlay (
        VStack {
          HStack {
            Spacer()
            Text("ARTICLE")
              .foregroundStyle(Color.gray.opacity(0.6))
              .padding(.trailing, 6)
              .padding(.top, 6)

          }
          Spacer()
          VStack {
            HStack {
              Text(article.title)
                .foregroundStyle(.white)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .padding(.leading, 10)
            }
            HStack {
              Text(article.publishingDate)
                .foregroundStyle(.white)
                .font(.body)
                .padding(.leading)
              Spacer()
            }
          }.padding(.vertical, 5).background {
            LinearGradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.3), Color.black.opacity(0.1)], startPoint: .bottom, endPoint: .top).blur(radius: 5).frame(width: 200).clipShape(CustomCorner(corners: [.bottomLeft, .bottomRight], radius: 20))
          }
        }
        )
      }
    }
}

#Preview {
  ArticleCoverCardView(article: .constant(underStandingDeafBlindnessArticle))
}
