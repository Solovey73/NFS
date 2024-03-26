//
//  MyTableViewCell.swift
//  NFS
//
//  Created by Вячеслав on 19/3/24.
//

import Foundation
import UIKit

private extension CGFloat {
    static let top: Self = 10
    static let left: Self = 20
    static let width: Self = 80
    static let height: Self = 80
}

private enum Constants {
    static let fontSize: CGFloat = 16
    static let fontWeight: UIFont.Weight = .bold
}

class MyTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    // MARK: - UI
    private let optionIcon: UIImageView = {
       let image = UIImageView()
       image.translatesAutoresizingMaskIntoConstraints = false
       return image
    }()
    
    private let optionTitle: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: Constants.fontSize, weight: Constants.fontWeight)
       label.textColor = .label
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(views: optionIcon, optionTitle)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Flow funcs
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            optionIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat.top),
            optionIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: CGFloat.left),
            optionIcon.widthAnchor.constraint(equalToConstant: CGFloat.width),
            optionIcon.heightAnchor.constraint(equalToConstant: CGFloat.height),
            
            optionTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height),
            optionTitle.leftAnchor.constraint(equalTo: optionIcon.rightAnchor, constant: CGFloat.left)
        ])
    }
    //нижние 2 метода объеденить
    func configure(profile: UserSettings, index: Int) {
        switch index {
        case 1: optionTitle.text = profile.car.CarString
        case 2: optionTitle.text = profile.lavel.GameDifficultyLevelString
        case 3: optionTitle.text = profile.type.TypeControlString
        default: break
        }
        
    }
    
    func configureProfileCell(profile: UserSettings) {
        if profile.photoUser == "AppIcon" {
            optionIcon.image = UIImage(named: "AppIcon")
        } else {
            optionIcon.image = StorageManager().loadImage(name: profile.photoUser)
        }
        optionTitle.text = profile.nameUser
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.optionIcon.image = nil
    }
}
