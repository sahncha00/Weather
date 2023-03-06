//
//  WeatherInfoCellType.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import Foundation

struct WeatherInfoCellType: Hashable {
  enum Style {
    case main, detail
  }

  var style: Style = .detail
  var icon: String?
  var title: String
  var subTitle: String?
  var description: String?
}
