//
//  File.swift
//  
//
//  Created by Timon Harz on 16.02.24.
//

import Foundation
import SwiftUI

struct Article: Identifiable, Hashable {
  let id = UUID()
  var title: String
  var subtitle: String
  var coverSubTitle: String
  var coverImage: String
  var coverSubImage: [String]
  var paragraphs: [Paragraph]
  var author: String
  var publishingDate: String
  var readLength: String
  var footnote: String
  var sources: String
  var uniqueArticleIdentifier: String
}

//MARK: - Articles

//Helen Keller and her work

let helenKellerArticle: Article = {
  let paragraph1 = Paragraph(title: "", textContent: "In history's pages, few figures shine as brightly as Helen Keller, embodying resilience, determination, and triumph over adversity. Born in 1880 in Tuscumbia, Alabama, her story transcends mere biography; it is a testament to the indomitable power of the human spirit, particularly within the deafblind community.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph2 = Paragraph(title: "", textContent: "Helen Keller's early years were marked by profound challenges. At just 19 months old, she fell ill with what doctors later diagnosed as 'brain fever', leaving her both deaf and blind. In a world of silence and darkness, she confronted unimaginable obstacles in her quest for understanding and communication.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph3 = Paragraph(title: "The Lifelong Partnership with Anne Sullivan", textContent: "Anne Sullivan, the extraordinary teacher who became Helen Keller's lifelong companion and mentor. Through unwavering dedication and innovative methods, Sullivan unlocked the door to Helen's world, introducing her to language through tactile sign language spelled out in her palm. This breakthrough marked the start of Helen's remarkable journey toward education, enlightenment, and advocacy.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph4 = Paragraph(title: "Advocacy and Social Justice Work", textContent: "Despite her sensory impairments, Helen Keller refused to be defined by her disabilities. With Anne Sullivan's guidance, she learned Braille, mastered the manual alphabet, and pursued higher education, eventually graduating cum laude from Radcliffe College in 1904, becoming the first deafblind person to earn a Bachelor of Arts degree.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph5 = Paragraph(title: "", textContent: "Helen Keller's impact extended beyond academia. She became a passionate advocate for social justice, championing causes like women's suffrage, workers' rights, and disability rights. Her steadfast commitment to equality laid the groundwork for significant societal change, inspiring generations.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph6 = Paragraph(title: "A Lasting Legacy of Courage and Hope", textContent: "Throughout her life, Helen Keller traveled the world, delivering impassioned speeches and spreading her message of hope, perseverance, and empathy. Meeting with world leaders like Presidents Franklin D. Roosevelt and Dwight D. Eisenhower, she used her platform to amplify the voices of marginalized communities and promote understanding among diverse populations.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let quoteParaGraph = Paragraph(title: "", textContent: "", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "'The only thing worse than being blind is having sight but no vision.' ¹", by: "Helen Keller (1880 - †1920)", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph7 = Paragraph(title: "", textContent: "Helen Keller's legacy endures as a beacon of inspiration for millions living with sensory impairments. Her autobiography, 'The Story of My Life', continues to captivate readers worldwide, offering profound insights into the human experience and the power of resilience. While honored with numerous accolades, including the Presidential Medal of Freedom, her greatest legacy lies in reshaping society's perception of disability and revealing the boundless potential of the human spirit. As we celebrate Helen Keller's life and legacy, let us remember her not just as a historical figure but as a symbol of courage, determination, and hope, inspiring generations within the deafblind community and beyond.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraphs = [paragraph1, paragraph2, paragraph3, paragraph4, paragraph5, paragraph6, quoteParaGraph, paragraph7]
  return Article(title: "About Helen Keller and her work", subtitle: "A Beacon of Inspiration for the Deafblind Community", coverSubTitle: "Composition designed by Timon Harz", coverImage: "HelenKellerCover", coverSubImage: [], paragraphs: paragraphs, author: "Timon Harz", publishingDate: "16.02.2024", readLength: "2min", footnote: "", sources: """
    1. https://en.wikipedia.org/wiki/Helen_Keller
""", uniqueArticleIdentifier: "article_HK")
}()
let underStandingDeafBlindnessArticle: Article = {
  let paragraph1 = Paragraph(title: "", textContent: "Deafblindness is a unique sensory impairment that significantly affects an individual's ability to perceive and interact with the world. Unlike blindness or deafness alone, deafblindness presents a dual challenge, often creating profound barriers to communication, mobility, and social interaction. In this article, we delve into the complexities of deafblindness, exploring its causes, effects, and strategies for supporting individuals living with this condition.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph2 = Paragraph(title: " A Dual Sensory Loss", textContent: "Deafblindness is characterized by the simultaneous impairment of both hearing and vision. Individuals with deafblindness experience varying degrees of sensory loss, ranging from mild to severe. While some may have residual hearing or vision, others may rely entirely on tactile or auditory cues for communication and navigation.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph3 = Paragraph(title: "", textContent: "It's important to recognize that deafblindness is not simply the sum of deafness and blindness but represents a unique sensory experience that profoundly shapes an individual's perception of the world.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let wordwideDeafblindCountParagraph = Paragraph(title: "", textContent: "", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "467,687,924 ¹", by: "World wide population affected by some degree of deafblindness (2018)", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph4 = Paragraph(title: "The global perspective on deafblindness", textContent: "Deafblindness isn't confined by borders; it's a worldwide challenge affecting individuals across diverse cultures and communities. While the specific causes and prevalence rates may vary globally, the fundamental barriers faced by those with dual sensory impairment remain consistent. Whether in low-income regions with limited resources or high-income areas with better access to support services, individuals with deafblindness encounter obstacles to education, employment, healthcare, and social inclusion.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let statisticsparagraph = Paragraph(title: "", textContent: "", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(DeafblindnessStatisticView()))
  let paragraph5 = Paragraph(title: "Causes and Types of Deafblindness", textContent: "Deafblindness can result from a wide range of congenital and acquired conditions, including: Usher Syndrome: A genetic disorder that causes hearing loss and progressive vision loss. Congenital Rubella Syndrome: A condition resulting from maternal rubella infection during pregnancy, leading to deafness, blindness, and other complications. Age-related Conditions: Such as age-related macular degeneration and presbycusis (age-related hearing loss).", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraph6 = Paragraph(title: "Promoting Awareness and Understanding", textContent: "Raising awareness about deafblindness is essential for fostering inclusivity and understanding within society. By educating the public about the challenges faced by individuals with deafblindness and advocating for accessible accommodations and support services, we can work towards creating a more inclusive and equitable world for all.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let endParagraph = Paragraph(title: "", textContent: "In conclusion, deafblindness is a complex and multifaceted condition that presents unique challenges for individuals living with this sensory impairment. By increasing awareness, providing support, and promoting inclusivity, we can empower individuals with deafblindness to lead fulfilling and meaningful lives. Together, we can navigate the silent darkness and create a more inclusive society for all.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let paragraphs = [paragraph1, paragraph2, paragraph3, wordwideDeafblindCountParagraph, paragraph4, statisticsparagraph, paragraph5, paragraph6, endParagraph]
  return Article(title: "Understanding deafblindness", subtitle: "Navigating the Silent Darkness in a world where you must rely on your remaining senses.", coverSubTitle: "Illustration showcasing 'Hello World' both in English and Braille, designed by Timon Harz", coverImage: "UnderstandingDeafblindnessCover", coverSubImage: [], paragraphs: paragraphs, author: "Timon Harz", publishingDate: "17.02.2024", readLength: "3min", footnote: "", sources: "    1. https://wfdb.eu", uniqueArticleIdentifier: "article_UD")
}()
let howToUseTheoArticle: Article = {
  let firstParagraph = Paragraph(title: "", textContent: "Theo was created to meet the needs of deafblind individuals in modern society. It does not require sight or hearing, but rather relies on touch. Once set up by a caregiver, the deafblind user can easily return to the simple chat view by shaking the device. In addition, there are many other features that make it easier for deafblind individuals to communicate with the outside world.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let purposeParagraph = Paragraph(title: "Purpose of Theo", textContent: "Theo aims to empower deafblind individuals by providing them with a means to communicate effectively and independently. Through innovative haptic feedback patterns and gesture-based controls, Theo enables users to access information, communicate with others, and navigate digital interfaces with ease.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let gesturesParagraph1 = Paragraph(title: "Navigating with gestures", textContent: "Gestures are easy to remember and once you have a certain skill set Theo becomes more and more convient to use. You can always find a recap of the gestures under the Explore tab.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(
    GestureReelView()
    ))
  let communicatingParagraph1 = Paragraph(title: "Writing with morse code", textContent: "", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [ParagraphImage(images: ["YouTextField"], subtitle: "", copyright: "")], customView: AnyView(EmptyView()))
  let communicatingParagraph2 = Paragraph(title: "", textContent: "Apply the Gestures you learned here in this canvas. When adding a line or a dot you directly get a tactile feedback. This Texfield is meant for the deafblind individual. Click on the speaker in the top leading corner or pinch out in the morse canvas to speak out loudly what you wrote. You may ask how deafblind individuals are able to enter morse code in such a small field? Well, for that they can just shake the device or swipe up and the simple chat will open.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let accessibilityParagraph = Paragraph(title: "Accessibility by design", textContent: "", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [ParagraphImage(images: ["EditViewPreview"], subtitle: "", copyright: "")], customView: AnyView(EmptyView()))
  let accessibilityParagraph2 = Paragraph(title: "", textContent: "The simple chat doesn't need to be seen nor heard, it is felt. Tap anywhere on the screen to enter morse code into the 'You' field. When you zoom in here you do not feel your morse code, instead you feel what you conversation partner said or entered. Swipe up here to start transcribing what the person in front of you is saying. This view will appear in a bright turquoise.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let useCaseParagraph = Paragraph(title: "Using Theo in the real world", textContent: "As a developer, I have to admit that learning Theo is hard. It is like learning a new language in a country you have never been to. What makes it particularly hard is the lack of two major senses, yet with persistence and creativity Theo will find use for deafblind individuals. Theo was made for the crazy ones, the once not accepting the state of the art.", attributedTextContent: AttributedString(), quote: Quote(quoteTextContent: "", by: "", showApostrophe: false), images: [], customView: AnyView(EmptyView()))
  let allParagraphs = [firstParagraph, purposeParagraph, gesturesParagraph1, communicatingParagraph1, communicatingParagraph2, accessibilityParagraph, accessibilityParagraph2, useCaseParagraph]
  return Article(title: "How to use Theo - Guide", subtitle: "Master Gestures, find appropiate use and communicate better", coverSubTitle: "Cover showcasing the main component of Theo: Morse Code", coverImage: "HowToCover", coverSubImage: [], paragraphs: allParagraphs, author: "Timon Harz", publishingDate: "24.02.2024", readLength: "1min", footnote: "", sources: "", uniqueArticleIdentifier: "article_HTT")
}()
let allArticles: [Article] = [howToUseTheoArticle, helenKellerArticle, underStandingDeafBlindnessArticle]

class ArticleDataController {

  static let shared = ArticleDataController()

  func getOtherArticles(excluding id: UUID) -> [Article] {
    var remainingArticles = [Article]()

    for article in allArticles {
      if article.id != id {
        remainingArticles.append(article)
      }
    }
    return remainingArticles
  }
}

#Preview {
  ArticleView(article: .constant(howToUseTheoArticle))
}
