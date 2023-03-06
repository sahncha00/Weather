//
//  WeatherInfoMainCell.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import UIKit

class WeatherInfoMainCell: UITableViewCell {
  static let identifier = "weather_info_main_cell"

  lazy var cityNameLabel = UILabel()
  lazy var temperatureLabel = UILabel()
  lazy var iconImageView = UIImageView()
  lazy var descriptionLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupSubviews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubviews() {
    contentView.addSubview(cityNameLabel)
    cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(temperatureLabel)
    temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(iconImageView)
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(descriptionLabel)
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    cityNameLabel.font = .systemFont(ofSize: 32, weight: .semibold)
    temperatureLabel.font = .systemFont(ofSize: 50, weight: .ultraLight)
    descriptionLabel.font = .systemFont(ofSize: 26, weight: .regular)
    selectionStyle = .none
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      cityNameLabel.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
      cityNameLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
      cityNameLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
      temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
      temperatureLabel.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
      temperatureLabel.trailingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
      descriptionLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor),
      iconImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
      iconImageView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
      iconImageView.heightAnchor.constraint(equalToConstant: 50),
      iconImageView.widthAnchor.constraint(equalToConstant: 50),
      iconImageView.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
    ])
  }

  func setCityName(_ name: String) {
    cityNameLabel.text = name
  }

  func setTemperature(_ temperature: String?) {
    if let temp = temperature {
      temperatureLabel.text = "\(temp)°"
    } else {
      temperatureLabel.text = "-"
    }
  }

  func setDescription(_ description: String?) {
    descriptionLabel.text = description ?? "-"
  }
}
