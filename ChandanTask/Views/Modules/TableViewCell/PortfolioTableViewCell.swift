//
//  PortfolioTableViewCell.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 04/09/25.
//

import UIKit

final class PortfolioTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let ltpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.text = "LTP:"
        return label
    }()
    
    private let ltpValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let qtyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.text = "NET QTY:"
        return label
    }()
    
    private let qtyValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let pnlTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.text = "P&L:"
        return label
    }()
    
    private let pnlValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGreen
        return label
    }()
    
    // MARK: - Init
    
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
        
        let topStack = UIStackView(arrangedSubviews: [symbolLabel, UIView(), ltpTitleLabel, ltpValueLabel])
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.spacing = 4
        
        let bottomStack = UIStackView(arrangedSubviews: [qtyTitleLabel, qtyValueLabel, UIView(), pnlTitleLabel, pnlValueLabel])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
        mainStack.axis = .vertical
        mainStack.spacing = 6
        
        contentView.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with item: UserHolding) {
        let isProfitableToday = item.isProfitableToday
        symbolLabel.text = item.symbol
        ltpValueLabel.text = "\(item.ltp.toINR())"
        qtyValueLabel.text = "\(item.quantity)"
        pnlValueLabel.text = "\(item.totalPnlCurrentValue.toINR())"
        pnlValueLabel.textColor = isProfitableToday ? .systemGreen : .systemRed
    }
}
