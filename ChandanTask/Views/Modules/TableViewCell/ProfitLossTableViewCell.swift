//
//  ProfitLossTableViewCell.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 05/09/25.
//

import UIKit

final class PortfolioDescriptionTableViewCell: UITableViewCell {
    
    private let descriptionView: ProfitLossDescriptionView = ProfitLossDescriptionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func setupLayout() {
        selectionStyle = .none
        self.backgroundColor = UIColor(named: "LightGray") ?? .white
        
        contentView.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with item: ProfitLossDescriptionView.Model) {
        descriptionView.model = item
    }
}

#if DEBUG
extension PortfolioDescriptionTableViewCell {
    struct TestHook {
        private let base: PortfolioDescriptionTableViewCell
        init(_ base: PortfolioDescriptionTableViewCell) { self.base = base }

        var descriptionView: ProfitLossDescriptionView { base.descriptionView }
        var backgroundColor: UIColor? { base.backgroundColor }
        var selection: UITableViewCell.SelectionStyle { base.selectionStyle }
    }

    var testHook: TestHook { TestHook(self) }
}
#endif
