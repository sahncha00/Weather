//
//  MockWeatherInfoFetcher.swift
//  WeatherTests
//
//  Created by Sahn Cha on 3/6/23.
//

import Foundation
import Combine
import UIKit
@testable import Weather

enum MockError: Error {
  case general
}

class MockWeatherInfoFetcher: WeatherInfoFetchable {
  var weatherFeed: WeatherInfo?

  func fetchWeatherInfo(city: String) -> AnyPublisher<WeatherInfo, Error> {
    return mockResult()
  }

  func fetchWeatherInfo(lat: Double, lon: Double) -> AnyPublisher<WeatherInfo, Error> {
    return mockResult()
  }

  func loadIcon(icon: String) -> AnyPublisher<UIImage?, Never> {
    // Always send sample image
    return Result<UIImage?, Never>
      .success(UIImage(systemName: "star"))
      .publisher
      .eraseToAnyPublisher()
  }

  private func mockResult() -> AnyPublisher<WeatherInfo, Error> {
    // Send success if `weatherFeed` is not nil
    if let weather = weatherFeed {
      return Result<WeatherInfo, Error>
        .success(weather)
        .publisher
        .eraseToAnyPublisher()
    } else {
      return Result<WeatherInfo, Error>
        .failure(MockError.general)
        .publisher
        .eraseToAnyPublisher()
    }
  }

}
