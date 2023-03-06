//
//  WeatherInfoDetailCell.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import UIKit

class WeatherInfoDetailCell: UITableViewCell {
  static let identifier = "weather_info_detail_cell"

  lazy var iconImageView = UIImageView()
  lazy var titleLabel = UILabel()
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
    contentView.addSubview(iconImageView)
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(descriptionLabel)
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    selectionStyle = .none
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
      iconImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
      iconImageView.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
      descriptionLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
    ])
  }

  func setIcon(_ iconName: String?) {
    if let icon = iconName {
      let image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
      iconImageView.image = image
    } else {
      iconImageView.image = nil
    }
  }
}
