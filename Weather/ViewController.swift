//
//  ViewController.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
  private typealias DataSource = UITableViewDiffableDataSource<Int, WeatherInfoCellType>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, WeatherInfoCellType>

  private var dataSource: DataSource!

  private let viewModel = WeatherViewModel()
  private lazy var contentView = WeatherView()

  private var cancellables = Set<AnyCancellable>()

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    configureDataSource()
    setupViewModelBinding()

    // Load previous search result or get geolocation if none exists
    loadCurrentCity()
  }

  private func configureDataSource() {
    contentView.tableView.register(WeatherInfoMainCell.self, forCellReuseIdentifier: WeatherInfoMainCell.identifier)
    contentView.tableView.register(WeatherInfoDetailCell.self, forCellReuseIdentifier: WeatherInfoDetailCell.identifier)

    // Table view data source
    dataSource = DataSource(tableView: contentView.tableView, cellProvider: { [weak self] (tableView, indexPath, weatherInfoCellType) -> UITableViewCell? in

      switch weatherInfoCellType.style {
      case .main:
        // Main weather info cell
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoMainCell.identifier, for: indexPath) as? WeatherInfoMainCell
        cell?.setCityName(weatherInfoCellType.title)
        cell?.setTemperature(weatherInfoCellType.subTitle)
        cell?.setDescription(weatherInfoCellType.description)
        cell?.iconImageView.image = nil
        if let self = self {
          // bind weather icon
          self.viewModel.$weatherIcon
            .receive(on: DispatchQueue.main)
            .sink { image in
              cell?.iconImageView.image = image
            }
            .store(in: &self.cancellables)
        }
        return cell
      case .detail:
        // Extra info
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoDetailCell.identifier, for: indexPath) as? WeatherInfoDetailCell
        cell?.setIcon(weatherInfoCellType.icon)
        cell?.titleLabel.text = weatherInfoCellType.title
        cell?.descriptionLabel.text = weatherInfoCellType.description
        return cell
      }
    })
  }

  private func setupViewModelBinding() {
    // Search bar text binding
    NotificationCenter.default
      .publisher(for: UISearchTextField.textDidChangeNotification, object: contentView.searchBar.searchTextField)
      .debounce(for: 0.5, scheduler: DispatchQueue.main)
      .map {
        ($0.object as! UISearchTextField).text ?? ""
      }
      .sink { [weak self] searchText in
        if searchText.count > 0 {
          self?.viewModel.fetch(city: searchText)
        }
      }
      .store(in: &cancellables)

    // Weather info binding
    viewModel.$weatherInfo
      .receive(on: DispatchQueue.main)
      .sink { [weak self] info in
        if let info = info {
          self?.updateWeatherView(info)
          self?.updateCurrentCity(info)
        }
      }
      .store(in: &cancellables)

    // Activity indicator binding
    viewModel.$isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] loading in
        if loading {
          self?.contentView.spinner.startAnimating()
        } else {
          self?.contentView.spinner.stopAnimating()
        }
      }
      .store(in: &cancellables)
  }

  private func updateWeatherView(_ weatherInfo: WeatherInfo) {
    var snapshot = Snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems([
      WeatherInfoCellType(style: .main, icon: weatherInfo.weather.first?.icon, title: weatherInfo.name, subTitle: String(weatherInfo.main.temp), description: weatherInfo.weather.first?.main),
      WeatherInfoCellType(icon: "thermometer.medium", title: "Feels like", description: String(weatherInfo.main.feelsLike)),
      WeatherInfoCellType(icon: "thermometer.high", title: "Max Temperature", description: String(weatherInfo.main.tempMax)),
      WeatherInfoCellType(icon: "thermometer.low", title: "Min Temperature", description: String(weatherInfo.main.tempMin)),
      WeatherInfoCellType(icon: "humidity", title: "Humidity", description: String(weatherInfo.main.humidity)),
      WeatherInfoCellType(icon: "wind", title: "Wind speed", description: String(weatherInfo.wind.speed)),
      WeatherInfoCellType(icon: "wind", title: "Wind direction", description: String(weatherInfo.wind.deg)),
    ])
    dataSource.apply(snapshot, animatingDifferences: true)
  }

  private func updateCurrentCity(_ weatherInfo: WeatherInfo) {
    // Save fetched city name to UserDefaults
    UserDefaults.standard.set(weatherInfo.name, forKey: "city")
  }

  private func loadCurrentCity() {
    // If there's previously fetched city, use that one. Otherwise, get geo-location.
    if let city = UserDefaults.standard.string(forKey: "city") {
      viewModel.fetch(city: city)
    } else {
      viewModel.getLocation()
    }
  }
}
