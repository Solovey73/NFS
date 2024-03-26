//
//  Extension + StartScreenViewController.swift
//  NFS
//
//  Created by Вячеслав on 13/2/24.
//

import Foundation
import UIKit

//: MARK: - Constants
private enum Сonstants {
    static let nameOfRoadGif = "road"
}

extension StartScreenViewController {
    
    // MARK: - Public Methods
    
    func setGIFAndThreeButtons() {
        setGIF()
        addThreeButtons()
    }
    
    // MARK: - Private Methods
    
    private func setGIF() {
        let imageview = UIImageView(image: UIImage.gifImageWithName(Сonstants.nameOfRoadGif))
        imageview.frame = UIScreen.main.bounds
        view.addSubview(imageview)
    }
    
    private func addThreeButtons() {
        let stackView = UIStackView.mySettings()
        let pushButtonToRaceScreenViewController = UIButton(title: "RACE",
            action: #selector(presentRaceScreenViewController), target: self)
        let pushButtonToSettingsScreenViewController = UIButton(title: "SETTINGS",   action: #selector(presentSettingsScreenViewController), target: self)
        let pushButtonToRecordsScreenViewController = UIButton(title: "RECORDS",     action: #selector(presentRecordsScreenViewController), target: self)
        
        stackView.addArrangedSubview(pushButtonToRaceScreenViewController)
        stackView.addArrangedSubview(pushButtonToSettingsScreenViewController)
        stackView.addArrangedSubview(pushButtonToRecordsScreenViewController)
        stackView.frame = CGRect(origin: CGPoint(), size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
        stackView.center = view.center
        view.addSubview(stackView)
    }
    
    // MARK: - @objc Methods
    
    @objc private func presentRaceScreenViewController() {
        navigationController?.pushViewController(RaceScreenViewController(), animated: true)
    }
    @objc private func presentSettingsScreenViewController() {
        navigationController?.pushViewController(SettingsScreenViewController(), animated: true)
    }
    @objc private func presentRecordsScreenViewController() {
        navigationController?.pushViewController(RecordsScreenViewController(), animated: true)
    }
}
private extension UIButton {
    convenience init(title: String, action: Selector, target: Any ) {
        self.init(type: .system)
        self.configuration = .filled()
        self.setTitle(title, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
