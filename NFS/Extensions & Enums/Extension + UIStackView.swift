//
//  Extension + UIStackView.swift
//  NFS
//
//  Created by Вячеслав on 13/2/24.
//
import Foundation
import UIKit

private enum UIStackViewConstants {
    static let spacing: CGFloat = 0
}

extension UIStackView {
    static func mySettings() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = UIStackViewConstants.spacing
        return stackView
    }
}
