//
//  Extension + UIView.swift
//  NFS
//
//  Created by Вячеслав on 11/3/24.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(views: UIView...) {
        views.forEach { addSubview($0)}
    }
    
    
}

extension CALayer {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        cornerRadius = radius
        maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}
