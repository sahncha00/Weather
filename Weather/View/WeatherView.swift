//
//  WeatherView.swift
//  Weather
//
//  Created by Sahn Cha on 3/6/23.
//

import UIKit

class WeatherView: UIView {

  lazy var titleLabel = UILabel()
  lazy var searchBar = UISearchBar()
  lazy var tableView = UITableView(frame: .zero)
  lazy var spinner = UIActivityIndicatorView(style: .medium)

  init() {
    super.init(frame: .zero)
    backgroundColor = .systemBackground //

    setupSubviews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubviews() {
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(spinner)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    addSubview(searchBar)
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.text = "Weather"
    titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    spinner.hidesWhenStopped = true
    searchBar.placeholder = "Search cities..."
    searchBar.searchBarStyle = .minimal
    tableView.keyboardDismissMode = .onDrag
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor, constant: 10),
      titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
      spinner.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      spinner.trailingAnchor.constraint(equalTo: self.readableContentGuide.trailingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: spinner.leadingAnchor, constant: 10),
      searchBar.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: self.readableContentGuide.trailingAnchor),
      searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
