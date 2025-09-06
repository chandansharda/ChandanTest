//
//  ProfitLossView.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 05/09/25.
//

import UIKit

final class ProfitLossExpandableView: UIView {
    
    // MARK: - Model
    struct Model {
        let totalCurrentValue: Double
        let totalInvestment: Double
        let todaysProfitAndLoss: Double
        let totalProfitLoss: Double
        
        func returnList() -> [ProfitLossDescriptionView.Model] {
            [
                .init(key: "Current value*", value: "\(totalCurrentValue.toINR())"),
                .init(key: "Total investment*", value: "\(totalInvestment.toINR())"),
                .init(key: "Today's Profit & Loss*", value: "\(todaysProfitAndLoss.toINR())", isProfitable: todaysProfitAndLoss >= 0),
            ]
        }

        func returnProfitAndLoss() -> ProfitLossDescriptionView.Model {
            .init(key: "Profit & Loss*", value: "\(totalProfitLoss.toINR())",
                  isProfitable: totalProfitLoss >= 0,
                  expandButtonVisible: true
            )
        }
    }
    
    // MARK: - Section
    private enum Section {
        case main
    }
    
    // MARK: - UI
    private let mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    private let tableFooterView: ProfitLossDescriptionView = ProfitLossDescriptionView()
    private let lineView: UIView = UIView()
    
    // MARK: - Data Source
    private var dataSource: UITableViewDiffableDataSource<Section, ProfitLossDescriptionView.Model>!
    private var tableViewHeightConstraint: NSLayoutConstraint?

    // MARK: - attributes
    var model: Model? {
        didSet {
            if let model {
                apply(model: model)
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupLayout()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupTableView() {
        mainTableView.register(
            PortfolioDescriptionTableViewCell.self,
            forCellReuseIdentifier: "PortfolioDescriptionTableViewCell"
        )
    }
    
    private func setupLayout() {
        self.backgroundColor = UIColor(named: "LightGray") ?? .white
        mainTableView.backgroundColor = UIColor(named: "LightGray") ?? .white
        tableFooterView.delegate = self
        self.roundTopCornersWithShadow()
        lineView.backgroundColor = .lightGray
        lineView.isHidden = true
        
        [mainTableView, lineView, tableFooterView].forEach { subView in
            addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableViewHeightConstraint = mainTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            mainTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lineView.topAnchor.constraint(equalTo: mainTableView.bottomAnchor),
            lineView.bottomAnchor.constraint(equalTo: tableFooterView.topAnchor),

            tableFooterView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableFooterView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableFooterView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableFooterView.heightAnchor.constraint(equalToConstant: ProfitLossDescriptionView.HEIGHT)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ProfitLossDescriptionView.Model>(
            tableView: mainTableView
        ) { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "PortfolioDescriptionTableViewCell",
                for: indexPath
            ) as? PortfolioDescriptionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
        
        mainTableView.dataSource = dataSource
    }
    
    // MARK: - Public
    func apply(model: Model) {
        tableFooterView.model = model.returnProfitAndLoss()
    }

    func applySnapShot(isExpanded: Bool) {
        guard let model else { return }
        lineView.isHidden = !isExpanded
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProfitLossDescriptionView.Model>()
        snapshot.appendSections([.main])
        if isExpanded {
            snapshot.appendItems(model.returnList(), toSection: .main)
        } else {
            snapshot.appendItems([], toSection: .main)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        updateTableViewHeight()
    }

    func updateTableViewHeight() {
        mainTableView.layoutIfNeeded()
        let newHeight = mainTableView.contentSize.height
        tableViewHeightConstraint?.constant = newHeight

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState]
        ) {
            self.superview?.layoutIfNeeded()
        }
    }
}

extension ProfitLossExpandableView: ProfitLossDescriptionViewPresentable {
    func didTapOnExpandView(isExpanded: Bool) {
        applySnapShot(isExpanded: isExpanded)
    }
}

#if DEBUG
extension ProfitLossExpandableView {
    struct TestHook {
        private let base: ProfitLossExpandableView
        init(_ base: ProfitLossExpandableView) { self.base = base }

        var tableView: UITableView { base.mainTableView }
        var footerView: ProfitLossDescriptionView { base.tableFooterView }
        var lineView: UIView { base.lineView }
        var tableViewHeightConstraint: NSLayoutConstraint? { base.tableViewHeightConstraint }

        var snapshotItemCount: Int {
            base.dataSource.snapshot().itemIdentifiers.count
        }
    }

    var testHook: TestHook { TestHook(self) }
}
#endif

