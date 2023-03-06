//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Sahn Cha on 3/6/23.
//

import XCTest
import Combine
@testable import Weather

final class WeatherTests: XCTestCase {

  private var viewModel: WeatherViewModel!
  private var mockWeatherInfoFetcher: MockWeatherInfoFetcher!
  private var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    super.setUp()

    mockWeatherInfoFetcher = MockWeatherInfoFetcher()
    viewModel = WeatherViewModel(weatherInfoFetcher: mockWeatherInfoFetcher)
  }

  override func tearDown() {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    mockWeatherInfoFetcher = nil
    viewModel = nil

    super.tearDown()
  }

  func test_shouldUpdateWeatherInfo() {
    mockWeatherInfoFetcher.weatherFeed =
    WeatherInfo(weather: [WeatherInfo.Weather(main: "Sunny", description: "Very sunny", icon: "star")], main: WeatherInfo.Main(temp: 50.0, feelsLike: 50.0, tempMin: 49.0, tempMax: 51.0, humidity: 60), wind: WeatherInfo.Wind(speed: 10, deg: 0), name: "test")

    // when
    viewModel.fetch(city: "test")

    // observe
    viewModel.$weatherInfo
      .sink { XCTAssertNotNil($0) }
      .store(in: &cancellables)

    let wait = XCTWaiter.wait(for: [expectation(description: "")], timeout: 0.2)
    if wait == .timedOut {
      viewModel.$weatherIcon
        .sink { XCTAssertNotNil($0) }
        .store(in: &cancellables)
    } else {
      XCTFail()
    }
  }

  func test_shouldFaiilUpdatingWeatherInfo() {
    mockWeatherInfoFetcher.weatherFeed = nil

    // when
    viewModel.fetch(city: "test")

    // observe
    viewModel.$weatherInfo
      .sink { XCTAssertNil($0) }
      .store(in: &cancellables)
  }

}
