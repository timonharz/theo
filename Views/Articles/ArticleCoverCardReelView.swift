//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 17.02.24.
//

import SwiftUI

struct ArticleCoverCardReelView: View {
  @Binding var articles: [Article]

  @Environment(\.dismiss) var dismiss

  @State private var showArticle: Bool = false

  @State private var currentArticle: Article = Article(title: "", subtitle: "", coverSubTitle: "", coverImage: "", coverSubImage: [], paragraphs: [], author: "", publishingDate: "", readLength: "", footnote: "", sources: "", uniqueArticleIdentifier: "")
    var body: some View {
      HStack {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach($articles, id: \.self) { article in
              Button(action: {
                self.currentArticle = article.wrappedValue
                showArticle = true
              }) {
                ArticleCoverCardView(article: article).frame(maxWidth: 200)
              }.buttonStyle(ScaledButtonStyle(strength: .medium))
            }
          }
        }.frame(maxWidth: .infinity)
      }.fullScreenCover(isPresented: $showArticle, content: {
        ArticleView(article: $currentArticle)
      })
    }
}

#Preview {
  ArticleCoverCardReelView(articles: .constant([helenKellerArticle]))
}
