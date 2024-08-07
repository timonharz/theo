//
//  File.swift
//  
//
//  Created by Timon Harz on 25.02.24.
//

import Foundation
import SwiftUI


extension View {
  @ViewBuilder
  func showCase(order: Int, title: String, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous, scale: CGFloat = 1) -> some View {
    self
      .anchorPreference(key: HighlightAnchorKey.self, value: .bounds) { anchor in
        let highlight = Highlight(anchor: anchor, title: title, cornerRadius: cornerRadius, style: style, scale: scale)
        return [order: highlight]

      }
  }
}
struct ShowCaseRoot: ViewModifier {
  var showHighlights: Bool
  var onFinished: () -> ()

  @State private var hightlightOrder: [Int] = []
  @State private var currentHighlight: Int = 0
  @State private var showView: Bool = false
  @State private var showTitle: Bool = false

  @Namespace private var animation
  func body(content: Content) -> some View {
    content
      .onPreferenceChange(HighlightAnchorKey.self) { value in
        hightlightOrder = Array(value.keys)
      }
      .overlayPreferenceValue(HighlightAnchorKey.self) { preferences in
        if hightlightOrder.indices.contains(currentHighlight) {
          if let highlight = preferences[hightlightOrder[currentHighlight]] {
            HighlightView(highlight)
          }
        }
      }
  }
  @ViewBuilder
  func HighlightView(_ highlight: Highlight) -> some View {
    GeometryReader { proxy in
      let highlightRect = proxy[highlight.anchor]
      let safeArea = proxy.safeAreaInsets

      Rectangle()
        .fill(.black.opacity(0.5))
        .reverseMask {
          Rectangle()
            .matchedGeometryEffect(id: "HIGHTLIGHTSHAPE", in: animation)
          .frame(width: highlightRect.width, height: highlightRect.height)
          .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
          .offset(x: highlightRect.minX - 2.5, y: highlightRect.minY + safeArea.top +  2.5)
        }
        .ignoresSafeArea()
        .onTapGesture {
          if currentHighlight >= hightlightOrder.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
              showView = false
            }
          } else {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
              currentHighlight += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
              showTitle = true
            }
          }
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showTitle = true
          }
        }
      Rectangle()
        .foregroundStyle(.clear)
        .frame(width: highlightRect.width + 20, height: highlightRect.height + 20)
        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
        .popover(isPresented: $showTitle, content: {
          Text(highlight.title)
            .padding(.horizontal, 20)

            .interactiveDismissDisabled()
        })
        .scaleEffect(highlight.scale)
        .offset(x: highlightRect.minX - 10, y: highlightRect.minY + safeArea.top +  10)
    }
  }
}

extension View {
  @ViewBuilder
  func reverseMask<Content: View>(alignment: Alignment = .topLeading, @ViewBuilder content: @escaping () -> Content) -> some View {
    self
      .mask {
        Rectangle()
          .overlay {
            content()
              .blendMode(.destinationOut)
          }
      }
  }
}

fileprivate struct HighlightAnchorKey: PreferenceKey {
  static var defaultValue: [Int: Highlight] = [:]

  static func reduce(value: inout [Int : Highlight], nextValue: () -> [Int : Highlight]) {
    value.merge(nextValue()) { $1 }
  }
}
#Preview {
  VStack {
    Circle().fill(.red).frame(width: 20, height: 20).showCase(order: 0, title: "Test", cornerRadius: 12)
  }.modifier(ShowCaseRoot(showHighlights: true, onFinished: {
    print("Onboarding done ")
  }))
}
