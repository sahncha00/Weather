//
//  WeatherInfo.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import Foundation

struct WeatherInfo: Codable {
  struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
  }

  struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
      case temp
      case feelsLike = "feels_like"
      case tempMin = "temp_min"
      case tempMax = "temp_max"
      case humidity
    }
  }

  struct Wind: Codable {
    let speed: Double
    let deg: Int
  }

  let weather: [Weather]
  let main: Main
  let wind: Wind
  let name: String
}
