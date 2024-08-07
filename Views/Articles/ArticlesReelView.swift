//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import SwiftUI

struct ArticlesReelView: View {
  var articles: [Article]

  @State private var currentArticle: Article = Article(title: "", subtitle: "", coverSubTitle: "", coverImage: "", coverSubImage: [], paragraphs: [], author: "", publishingDate: "", readLength: "", footnote: "", sources: "", uniqueArticleIdentifier: "")
  @State private var showArticleSheet: Bool = false
    var body: some View {
      HStack {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 20) {
            ForEach(articles, id: \.self) { article in
              Button(action: {
                self.currentArticle = article
                self.showArticleSheet = true
              }) {
                articleItem(article: article)
              }
            }
          }
        }.frame(maxWidth: .infinity)
      }.fullScreenCover(isPresented: $showArticleSheet, content: {
        ArticleView(article: $currentArticle)
      })
    }
  @ViewBuilder func articleItem(article: Article) -> some View {
    VStack(spacing: 0) {
      HStack {
        Image(article.coverImage)
          .resizable()
          .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 14))
          .aspectRatio(contentMode: .fill)
          .frame(maxWidth: 200)
      }
      VStack {
        HStack {
          Text(article.title)
            .foregroundStyle(Color("textColor"))
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
        }
        HStack {
          Spacer()
          Text(article.readLength)
            .foregroundStyle(.gray)
            .font(.caption)
            .padding(.trailing)
        }.padding(.bottom, 6)
      }.frame(maxHeight: 90)
    }.frame(width: 200).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 14))

  }
}

#Preview {
  ZStack {
    Color("BG").ignoresSafeArea(.all, edges: .all)
    ArticlesReelView(articles: [helenKellerArticle]).padding()
  }
}
