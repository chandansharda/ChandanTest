//
//  PortfolioViewController.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

import UIKit
import Combine

final class PortfolioViewController: UIViewController {

    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let searchBar = UISearchBar()
    private let expandableView = ProfitLossExpandableView()
    private let mainStackView = UIStackView()

    // MARK: - Diffable DataSource
    enum Section {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<Section, UserHolding>!
    private let viewModel: PortfolioViewModel
    private var cancellables = Set<AnyCancellable>()

    init(_ viewModel: PortfolioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupActivityIndicator()
        configureDataSource()
        bindViewModel()

        fetchData()
    }

    private func fetchData() {
        Task {
            await viewModel.fetchPortfolio()
        }
    }

    // MARK: - Setup Navigation
    private func setupNavigationBar() {

        let profileStack = BarButtonFactory.makeProfileSection(
            imageName: "ic_profile",
            title: "Portfolio"
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileStack)

        let sortButton = BarButtonFactory.makeIconButton(
            systemName: "arrow.up.arrow.down",
            fallbackAsset: "ic_sort",
            action: #selector(tappedOnSortButton),
            target: self
        )

        let divider = BarButtonFactory.makeDivider()

        let searchButton = BarButtonFactory.makeIconButton(
            systemName: "magnifyingglass",
            fallbackAsset: "ic_search",
            action: #selector(tappedOnSearchButton),
            target: self
        )

        let rightStack = BarButtonFactory.makeStack([sortButton, divider, searchButton])
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightStack)
    }

    // MARK: - Setup Indicator
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Setup UISearchBar
    private func setupSearchBar() {
        searchBar.delegate = self
    }

    // MARK: - Setup Table
    private func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(expandableView)
        tableView.register(PortfolioTableViewCell.self, forCellReuseIdentifier: "PortfolioTableViewCell")
        expandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),

            expandableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Configure DataSource
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, UserHolding>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioTableViewCell", for: indexPath) as? PortfolioTableViewCell else { return nil }
            cell.configure(with: item)
            return cell
        }
    }

    // MARK: - Apply Snapshot
    private func applySnapshot(withItems items: [UserHolding]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserHolding>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        expandableView.model = viewModel.getOveralPOrtfolioBalance()
    }

    // MARK: - bind view models
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    self.tableView.setBackgroundState(.none)
                    self.activityIndicator.stopAnimating()
                    
                case .loading:
                    self.tableView.setBackgroundState(.none)
                    self.activityIndicator.startAnimating()
                    
                case .loaded(let items):
                    self.tableView.setBackgroundState(.none)
                    self.activityIndicator.stopAnimating()
                    self.applySnapshot(withItems: items)
                    
                case .failed(let message):
                    self.activityIndicator.stopAnimating()
                    self.tableView.setBackgroundState(.error(message))
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - Navigation Bar
extension PortfolioViewController {
    @objc func tappedOnSearchButton() {
        print("tapped")
    }

    @objc func tappedOnSortButton() {
        print("tapped")
    }
}

// MARK: - Search bar delegates
extension PortfolioViewController: UISearchBarDelegate {
    
}
