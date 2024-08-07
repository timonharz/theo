//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import SwiftUI

struct ArticleView: View {
  @Environment(\.dismiss) var dismiss

  @Binding var article: Article

  let articleDataController = ArticleDataController.shared

  var suggestedArticles: [Article] {
    return articleDataController.getOtherArticles(excluding: article.id)
  }

  var sourcesIsEmpty: Bool {
    return article.sources.isEmpty
  }

  @AppStorage("articles_readAboutHK") var readHKArticle: Bool = false
  @AppStorage("articles_readUnderStandingDeafblindness") var readUnderderstadningDeafBlidness: Bool = false
  @AppStorage("articles_theoUserGuide") var readUserGuide: Bool = false

    var body: some View {
      NavigationStack {
        ZStack {
          VStack {
            ScrollView(.vertical, showsIndicators: true) {
              VStack {
                Spacer()
                titleSection().padding(.top, getSafeArea().top * 2)
                coverSection().frame(maxWidth: .infinity).padding()
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                  ForEach(article.paragraphs, id: \.self) { paragraph in
                    ParagraphView(paragraph: paragraph, isFirstParagraph: paragraph.textContent == article.paragraphs.first!.textContent).multilineTextAlignment(.leading)
                  }
                }.frame(maxWidth: getRect().width - 100, alignment: .leading)
                articleInformation().padding(.vertical)
                Divider()
                Spacer()
                sourcesAndReference()
                Divider()
                Spacer()
                donate()
                Divider()
                Spacer()
                otherArticles().padding(.vertical)
              }
            }
          }.padding()
        }
        .navigationTitle("Article").navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              dismiss()
            }) {
              Text("Done")
                .font(.headline)
            }
          }
        }
      }.onAppear(perform: {
        setTodoStatus()
      })
    }

  //MARK: - Title
  @ViewBuilder func titleSection() -> some View {
    VStack(alignment: .center) {
      HStack {
        Text(article.title)
          .foregroundStyle(Color("textColor"))
          .font(.system(size: 60))
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
      }
      HStack {
        Text(article.subtitle)
          .foregroundStyle(Color("textColor"))
          .font(.title)
          .multilineTextAlignment(.center)
      }
    }
  }
  //MARK: - Cover
  @ViewBuilder func coverSection() -> some View {
    VStack {
      HStack {
        Image("\(article.coverImage)Wide")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: getRect().width)
          .cornerRadius(12)

      }
      HStack {
        Text(article.coverSubTitle)
          .foregroundStyle(.gray)
          .font(.caption)
          .padding(.leading)
        Spacer()
      }
    }
  }
  //MARK: - Author and publishing date
  @ViewBuilder func articleInformation() -> some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text("Written by \(article.author)")
          .foregroundStyle(.gray)
          .padding(.leading)
        Spacer()
      }
      HStack {
        Text("Published: \(article.publishingDate)")
          .foregroundStyle(.gray)
          .padding(.leading)
        Spacer()
      }
    }.padding(.leading)
  }
  //MARK: - Sources and References
  @ViewBuilder func sourcesAndReference() -> some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Sources and References")
          .foregroundStyle(Color("textColor"))
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding(.leading)
        Spacer()
      }
      VStack(alignment: .leading) {
        if !sourcesIsEmpty {
          Text(article.sources)
            .foregroundStyle(Color.gray)
        } else {
          Text("No sources or references.")
            .foregroundStyle(Color.gray)
            .padding(.leading)
        }
      }
    }.padding(.vertical)
  }
  //MARK: - Donate
  @ViewBuilder func donate() -> some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Donate")
          .foregroundStyle(Color("textColor"))
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding(.leading)
        Spacer()
      }
      HStack {
        Button(action: {
          if let url = URL(string: "https://wfdb.eu/support/") {
                              UIApplication.shared.open(url)
                          }
        }) {
          Text("Support WDFB")
            .font(.headline)
            .frame(maxWidth: 200)
        }.tint(Color("accentColor"))
          .controlSize(.large)
          .clipShape(RoundedRectangle(cornerRadius: 30))
          .buttonStyle(.borderedProminent)
        Spacer()
      }
    }.padding(.vertical)
  }
  //MARK: - See also
  @ViewBuilder func otherArticles() -> some View {
    VStack(alignment: .leading) {
      HStack {
        Text("See also")
          .foregroundStyle(Color("textColor"))
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding(.leading)
        Spacer()
      }
      ArticleCoverCardReelView(articles: .constant(suggestedArticles)).frame(maxHeight: 300)
    }
    }

  private func setTodoStatus() {
    if article.uniqueArticleIdentifier == "article_HK" {
      readHKArticle = true
    } else if article.uniqueArticleIdentifier == "article_UD" {
      readUnderderstadningDeafBlidness = true
    } else if article.uniqueArticleIdentifier == "article_HTT" {
      readUserGuide = true
    }
  }
}

#Preview {
  ArticleView(article: .constant(helenKellerArticle))
}
