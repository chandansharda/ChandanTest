//
//  UITableView+MessagesBackground.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 04/09/25.
//

import UIKit

extension UITableView {
    
    enum BackgroundState {
        case none
        case message(String)
        case error(String)
    }
    
    func setBackgroundState(_ state: BackgroundState) {
        switch state {
        case .none:
            backgroundView = nil
            separatorStyle = .singleLine
            
        case .message(let text):
            backgroundView = makeLabelView(
                text: text,
                textColor: .secondaryLabel
            )
            separatorStyle = .none
            
        case .error(let text):
            backgroundView = makeLabelView(
                text: text,
                textColor: .systemRed
            )
            separatorStyle = .none
        }
    }
    
    private func makeLabelView(text: String, textColor: UIColor) -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = text
        messageLabel.textColor = textColor
        messageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView(frame: bounds)
        container.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        
        return container
    }
}
