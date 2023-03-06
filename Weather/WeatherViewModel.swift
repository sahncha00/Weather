//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import Foundation
import Combine
import CoreLocation
import UIKit

class WeatherViewModel: NSObject {
  private let locationManager = CLLocationManager()

  @Published var isLoading = false
  @Published var weatherInfo: WeatherInfo?
  @Published var weatherIcon: UIImage?

  private let weatherInfoFetcher: WeatherInfoFetchable
  private var cancellables = Set<AnyCancellable>()

  private var weatherIconCache = [String: UIImage]()

  init(weatherInfoFetcher: WeatherInfoFetchable = WeatherInfoFetcher()) {
    self.weatherInfoFetcher = weatherInfoFetcher
    super.init()

    locationManager.delegate = self
  }

  // Request user consent for location gathering
  func getLocation() {
    if locationManager.authorizationStatus == .authorizedAlways ||
        locationManager.authorizationStatus == .authorizedWhenInUse {
      locationManager.requestLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }

  func fetch(city: String) {
    initiateWeatherInfoFetch(weatherInfoFetcher.fetchWeatherInfo(city: city))
  }

  private func fetch(lat: Double, lon: Double) {
    initiateWeatherInfoFetch(weatherInfoFetcher.fetchWeatherInfo(lat: lat, lon: lon))
  }

  private func initiateWeatherInfoFetch(_ fetcher: AnyPublisher<WeatherInfo, Error>) {
    isLoading = true

    fetcher
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: { [weak self] fetchedWeatherInfo in
        self?.weatherInfo = fetchedWeatherInfo
        self?.loadIcon(fetchedWeatherInfo.weather.first?.icon)
      }
      .store(in: &cancellables)
  }

  private func loadIcon(_ icon: String?) {
    guard let icon = icon, icon.count > 0 else {
      weatherIcon = nil
      return
    }

    if let cachedIcon = weatherIconCache[icon] {
      weatherIcon = cachedIcon
      return
    }

    weatherIcon = nil
    weatherInfoFetcher.loadIcon(icon: icon)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] image in
        if let image = image {
          // Cache icon for later use
          self?.weatherIconCache[icon] = image
          self?.weatherIcon = image
        }
      }
      .store(in: &cancellables)
  }
}

extension WeatherViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last, !isLoading {
      // Fetch weather info based on the location
      fetch(lat: location.coordinate.latitude.binade, lon: location.coordinate.longitude.binade)
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
    case .denied, .notDetermined, .restricted:
      // TODO: follow up with unauthorized handling
      break
    @unknown default:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // TODO: error handling
  }
}
