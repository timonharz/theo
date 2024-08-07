//
//  SwiftUIView.swift
//  
//
//  Created by Timon Harz on 17.02.24.
//

import SwiftUI
import Charts

struct DeafblindnessStatisticView: View {
  @State private var currentPresentationTypeSelected: DeafblindnessPresentationType = .all

  var currentScaleDomain: ScaleDomain {
    switch currentPresentationTypeSelected {
    case .mildDeafblindness:
      return 0...20000000
    case .severeDeafblindess:
      return 0...1000000
    case .dueToAgeing:
      return 0...450000000
    case .all:
      return 0...45000000
    default:
      return 0...45000000
    }
  }

    var body: some View {
      VStack {
        HStack {
          Picker("", selection: $currentPresentationTypeSelected.animation(.spring)) {
            ForEach(DeafblindnessPresentationType.allCases, id: \.self) { type in
              Text(type.description)
            }
          }.pickerStyle(.segmented)
        }.frame(maxWidth: getRect().width - 150).padding()
        Chart {
          switch currentPresentationTypeSelected {
          case .mildDeafblindness:

            ForEach(onlyMildStatisticsData) { data in
              BarMark(
                x: .value("Continent", data.continent.description),
                y: .value("Count", data.numberOfCases)
              ).cornerRadius(12)
            }

          case .severeDeafblindess:

            ForEach(onlySeveryStatisticsData) { data in
              BarMark(
                x: .value("Continent", data.continent.description),
                y: .value("Count", data.numberOfCases)
              ).cornerRadius(12)
            }

          case .dueToAgeing:

            ForEach(onlyDueToAgeingStatisticsData) { data in
              BarMark(
                x: .value("Continent", data.continent.description),
                y: .value("Count", data.numberOfCases)
              ).cornerRadius(12)
            }

          case .all:

            ForEach(deafblindnessStatisticsData, id: \.continent) { data in
              BarMark(
                x: .value("Continent", data.continent.description),
                y: .value("Count", data.numberOfCases)
              ).foregroundStyle(by: .value("Type", data.presentationType.description)).cornerRadius(12)

            }
          }

        }.frame(height: 200).chartYAxisLabel("Cases").chartYScale(domain: 0 ... 450000000)

      }.onAppear() {
        print("mild statistics: \(onlyMildStatisticsData.count)")
        print("severe statistics: \(onlySeveryStatisticsData.count)")
        print("severe statistics: \(onlyDueToAgeingStatisticsData.count)")

      }
      .onChange(of: currentPresentationTypeSelected) { newVal in
        print("current presentation type: \(newVal.description)")
      }
    }
}

#Preview {
  DeafblindnessStatisticView().padding()
}
