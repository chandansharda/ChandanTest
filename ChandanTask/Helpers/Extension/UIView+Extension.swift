//
//  UIView+Extension.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 06/09/25.
//

import UIKit

extension UIView {
    func roundTopCornersWithShadow(cornerRadius: CGFloat = 16,
                                   shadowColor: UIColor = .black,
                                   shadowOpacity: Float = 0.2,
                                   shadowOffset: CGSize = .zero,
                                   shadowRadius: CGFloat = 6) {
        
        // Round only top corners
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // top-left & top-right
        
        // Enable shadow
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false  // Important: allow shadow outside
    }
}
