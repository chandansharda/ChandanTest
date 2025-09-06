//
//  NavigationBarButton.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

import UIKit

enum BarButtonFactory {

    static func makeIconButton(
        systemName: String,
        fallbackAsset: String? = nil,
        tintColor: UIColor = .white,
        action: Selector?,
        target: Any?
    ) -> UIButton {
        let button = UIButton(type: .system)

        // Prefer SF Symbol, fallback to asset
        var image: UIImage? = UIImage(systemName: systemName)
        if image == nil, let fallback = fallbackAsset {
            image = UIImage(named: fallback)
        }

        if let img = image?.withRenderingMode(.alwaysTemplate) {
            button.setImage(img, for: .normal)
        }

        button.tintColor = tintColor
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true

        if let action = action, let target = target {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        return button
    }

    static func makeDivider(color: UIColor = UIColor.white.withAlphaComponent(0.6)) -> UIView {
        let divider = UIView()
        divider.backgroundColor = color
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 24)
        ])
        return divider
    }

    static func makeStack(_ views: [UIView], spacing: CGFloat = 12) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.alignment = .center
        return stack
    }

    static func makeProfileSection(imageName: String, title: String) -> UIStackView {
        let profileImage = UIImageView(image: UIImage(named: imageName) ??
                                       UIImage(systemName: "person.circle"))
        profileImage.contentMode = .scaleAspectFit
        profileImage.tintColor = .white
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .white

        return makeStack([profileImage, titleLabel], spacing: 6)
    }
}
