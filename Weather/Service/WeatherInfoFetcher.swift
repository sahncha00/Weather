//
//  WeatherInfoFetcher.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import Foundation
import Combine
import UIKit

protocol WeatherInfoFetchable {
  func fetchWeatherInfo(city: String) -> AnyPublisher<WeatherInfo, Error>
  func fetchWeatherInfo(lat: Double, lon: Double) -> AnyPublisher<WeatherInfo, Error>
  func loadIcon(icon: String) -> AnyPublisher<UIImage?, Never>
}

class WeatherInfoFetcher: WeatherInfoFetchable {
  private let session = URLSession.shared
  private let url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
  private let appId = "e95c9437bfb6883c1c7330d359b91c12"

  func fetchWeatherInfo(city: String) -> AnyPublisher<WeatherInfo, Error> {
    var query = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    query.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "units", value: "imperial"),
      URLQueryItem(name: "appid", value: appId)
    ]

    return getWeatherInfo(request: URLRequest(url: query.url!))
  }

  func fetchWeatherInfo(lat: Double, lon: Double) -> AnyPublisher<WeatherInfo, Error> {
    var query = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    query.queryItems = [
      URLQueryItem(name: "lat", value: String(lat)),
      URLQueryItem(name: "lon", value: String(lon)),
      URLQueryItem(name: "units", value: "imperial"),
      URLQueryItem(name: "appid", value: appId)
    ]

    return getWeatherInfo(request: URLRequest(url: query.url!))
  }

  func loadIcon(icon: String) -> AnyPublisher<UIImage?, Never> {
    let iconUrl = "https://openweathermap.org/img/wn/\(icon)@2x.png"
    return session
      .dataTaskPublisher(for: URL(string: iconUrl)!)
      .map {
        UIImage(data: $0.data)
      }
      .replaceError(with: nil)
      .eraseToAnyPublisher()
  }

  private func getWeatherInfo(request: URLRequest) -> AnyPublisher<WeatherInfo, Error> {
    return session
      .dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: WeatherInfo.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
