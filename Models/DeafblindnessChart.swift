//
//  File.swift
//  
//
//  Created by Timon Harz on 17.02.24.
//

import Foundation
import SwiftUI

enum DeafblindnessPresentationType: String, CaseIterable {
  case mildDeafblindness = "MildDeafblindess"
  case severeDeafblindess = "SevereDeafblindness"
  case dueToAgeing = "DueToAgeing"
  case all = "All"

  var description: String {
    switch self {
    case .mildDeafblindness:
      return "Mild Deafblindness"
    case .severeDeafblindess:
      return "Severe Deafblindness"
    case .dueToAgeing:
      return "Deafblindness due to ageing (>75)"
    case .all:
      return "All"
    }
  }
}

enum Continents: String, CaseIterable {
  case europe = "Europe"
  case africa = "Africa"
  case asia = "Asia"
  case northAmerica = "North America"
  case southAmerica = "South America"
  case ocenania = "Ocenania"
  case worldwide = "Worldwide"

  var description: String {
    switch self {
    case .europe:
      return "Europe"
    case .africa:
      return "Africa"
    case .asia:
      return "Asia"
    case .northAmerica:
      return "North America"
    case .southAmerica:
      return "South America"
    case .ocenania:
     return "Oceania"
    case .worldwide:
      return "Worldwide"
    }
  }
}

struct DeafblindnessStatistic: Identifiable {
    let continent: Continents
    let presentationType: DeafblindnessPresentationType
    let numberOfCases: Int
  let id = UUID()
}

let deafblindnessStatisticsData: [DeafblindnessStatistic] = [
  DeafblindnessStatistic(continent: .europe, presentationType: .severeDeafblindess, numberOfCases: 1495272),
  DeafblindnessStatistic(continent: .europe, presentationType: .dueToAgeing, numberOfCases: 44858162),
  DeafblindnessStatistic(continent: .europe, presentationType: .mildDeafblindness, numberOfCases: 14952721),
  DeafblindnessStatistic(continent: .asia, presentationType: .severeDeafblindess, numberOfCases: 9282110),
  DeafblindnessStatistic(continent: .asia, presentationType: .mildDeafblindness, numberOfCases: 92821096),
  DeafblindnessStatistic(continent: .asia, presentationType: .dueToAgeing, numberOfCases: 278463287),
  DeafblindnessStatistic(continent: .africa, presentationType: .severeDeafblindess, numberOfCases: 2681196),
  DeafblindnessStatistic(continent: .africa, presentationType: .mildDeafblindness, numberOfCases: 26811963),
  DeafblindnessStatistic(continent: .africa, presentationType: .dueToAgeing, numberOfCases: 80435889),
  DeafblindnessStatistic(continent: .southAmerica, presentationType: .severeDeafblindess, numberOfCases: 1307925),
  DeafblindnessStatistic(continent: .southAmerica, presentationType: .mildDeafblindness, numberOfCases: 13079247),
  DeafblindnessStatistic(continent: .southAmerica, presentationType: .dueToAgeing, numberOfCases: 39237740),
  DeafblindnessStatistic(continent: .northAmerica, presentationType: .severeDeafblindess, numberOfCases: 737739),
  DeafblindnessStatistic(continent: .northAmerica, presentationType: .mildDeafblindness, numberOfCases: 7377393),
  DeafblindnessStatistic(continent: .northAmerica, presentationType: .dueToAgeing, numberOfCases: 22132179),
  DeafblindnessStatistic(continent: .ocenania, presentationType: .severeDeafblindess, numberOfCases: 85356),
  DeafblindnessStatistic(continent: .ocenania, presentationType: .mildDeafblindness, numberOfCases: 853556),
  DeafblindnessStatistic(continent: .ocenania, presentationType: .dueToAgeing, numberOfCases: 2560669)

]
var onlyMildStatisticsData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    statistic.presentationType == .mildDeafblindness
  }
}
var onlySeveryStatisticsData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    statistic.presentationType == .severeDeafblindess
  }
}
var onlyDueToAgeingStatisticsData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    statistic.presentationType == .dueToAgeing
  }
}

var europeDeafblindnessData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    statistic.continent == .europe
  }
}
var asiaDeafblindnessData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    statistic.continent == .asia
  }
}
var africaDeafblindnessData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    statistic.continent == .africa
  }
}
var northAmericaDeafBlindnessData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    return statistic.continent == .northAmerica
  }
}
var southAmericaDeafBlindnessData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    return statistic.continent == .southAmerica
  }
}
var oceaniaAmericaDeafBlindnessData: [DeafblindnessStatistic] {
  return deafblindnessStatisticsData.filter { statistic in
    return statistic.continent == .ocenania
  }
}
