//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import SwiftUI

struct ParagraphView: View {
  var paragraph: Paragraph

  var modifiedParagraph: String {
    return removeFirstCharacter(from: paragraph.textContent)
  }

  var isFirstParagraph: Bool

  var isQuote: Bool {
    return !paragraph.quote.quoteTextContent.isEmpty
  }

  var noTitle: Bool {
    return paragraph.title.isEmpty
  }
  var hasImagesAttached: Bool {
    return !paragraph.images.isEmpty
  }
    var body: some View {
      VStack(alignment: .leading) {
        if !noTitle {
          HStack {
            Text(paragraph.title)
              .font(.title2)
              .fontWeight(.bold)
              .multilineTextAlignment(.leading)

          }
        }
        VStack {
          if isFirstParagraph {

            HStack {
              Text(String(paragraph.textContent.first!))
                .foregroundStyle(Color("textColor"))
                .font(.system(size: 80))
              VStack {
                Text(modifiedParagraph)
                  .foregroundStyle(Color("textColor"))
                  .fixedSize(horizontal: false, vertical: true)
              }
            }


          } else {
            Text(paragraph.textContent)
              .fixedSize(horizontal: false, vertical: true)
          }
          Text(paragraph.attributedTextContent)
            .fixedSize(horizontal: false, vertical: true)
        }
        if isQuote {
          HStack {
            quote()
          }
        }
        if hasImagesAttached {
          HStack {
            ForEach(paragraph.images, id: \.self) { image in
              Image(image.images.first!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: CGFloat(getRect().width / CGFloat(paragraph.images.count))  - CGFloat(10))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
          }
        }
        paragraph.customView.padding(.bottom)
      }
    }
  func setFontSizeForFirstCharacter(text: String, fontSize: CGFloat) -> NSAttributedString {
      let attributedString = NSMutableAttributedString(string: text)

      // Set font size for the first character
      let range = NSRange(location: 0, length: 1)
    let rangeToEnd = NSRange(location: 0, length: text.count)
      attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)
    attributedString.addAttribute(.baselineOffset, value: -20, range: range)

      return attributedString
  }
  private func removeFirstCharacter(from str: String) -> String {
      if !str.isEmpty {
          let startIndex = str.index(after: str.startIndex)
          return String(str[startIndex...])
      } else {
          return str
      }
  }
  @ViewBuilder func quote() -> some View {
    VStack(alignment: .center) {
      HStack {
        if paragraph.quote.showApostrophe {
          Spacer()
          Text("'\(paragraph.quote.quoteTextContent)'")
          Spacer()
        } else {
          Spacer()
          Text(paragraph.quote.quoteTextContent)
          Spacer()
        }

      }  .font(.system(size: 40))
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
      HStack {
        Spacer()
        Text(paragraph.quote.by)
          .font(.title2)
          .foregroundStyle(.gray)
        Spacer()
      }
    }
  }
}

#Preview {
  ParagraphView(paragraph: helenKellerArticle.paragraphs.first!, isFirstParagraph: true)
}
#Preview {
  ArticleView(article: .constant(helenKellerArticle))
}
