//
//  ProfitLossDescriptionView.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 05/09/25.
//

import UIKit

protocol ProfitLossDescriptionViewPresentable: AnyObject {
    func didTapOnExpandView(isExpanded: Bool)
}

class ProfitLossDescriptionView: UIView {
    
    static let HEIGHT: CGFloat = 50
    
    struct Model: Hashable {
        init(key: String, value: String, isProfitable: Bool? = nil, expandButtonVisible: Bool = false) {
            self.key = key
            self.value = value
            self.isProfitable = isProfitable
            self.expandButtonVisible = expandButtonVisible
        }
        
        let key: String
        let value: String
        let isProfitable: Bool?
        let expandButtonVisible: Bool
    }

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let keyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()

    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        return button
    }()

    private var isExpanded: Bool = false

    var model: Model? {
        didSet {
            updateUI()
        }
    }
    weak var delegate: ProfitLossDescriptionViewPresentable?

    init(_ model: Model? = nil) {
        super.init(frame: .zero)
        self.model = model
        setupViews()
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        expandButton.addTarget(self, action: #selector(tappedOnExpandButton), for: .touchUpInside)
        updateExpandButtonImage()
        
        self.backgroundColor = .clear
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(keyLabel)
        mainStackView.addArrangedSubview(expandButton)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(valueLabel)
        expandButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            expandButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func updateUI() {
        guard let model = model else { return }
        keyLabel.text = model.key
        valueLabel.text = model.value
        if let profitable = model.isProfitable {
            valueLabel.textColor = profitable ? .systemGreen : .systemRed
        } else {
            valueLabel.textColor = .darkGray
        }
        expandButton.isHidden = !(model.expandButtonVisible)
    }

    private func updateExpandButtonImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: isExpanded ? "chevron.down" : "chevron.up", withConfiguration: config)
        expandButton.setImage(image, for: .normal)
    }

    @objc func tappedOnExpandButton() {
        isExpanded.toggle()
        updateExpandButtonImage()
        delegate?.didTapOnExpandView(isExpanded: isExpanded)
    }
}

#if DEBUG
extension ProfitLossDescriptionView {
    struct TestHook {
        private let base: ProfitLossDescriptionView
        init(_ base: ProfitLossDescriptionView) { self.base = base }
        
        var keyLabel: UILabel { base.keyLabel }
        var valueLabel: UILabel { base.valueLabel }
        var expandButton: UIButton { base.expandButton }
        var isExpanded: Bool { base.isExpanded }
    }
    
    var testHook: TestHook { TestHook(self) }
}
#endif
