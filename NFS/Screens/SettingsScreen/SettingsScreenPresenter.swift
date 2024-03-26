//
//  SettingsScreenPresenter.swift
//  NFS
//
//  Created by Вячеслав on 26/2/24.
//

import Foundation
import UIKit

protocol ISettingsScreenPresenter {
    func getProfileInfo() -> UserSettings
    func savePhotoButtonTapped(image: UIImage)
    func updatePlayerNameButtonTapped(name: String)
    func changeCarButtonTapped()
    func changeLevelButton()
    func changeTypeButtonTapped()
    func saveUserSettings()
}

class SettingsScreenPresenter: ISettingsScreenPresenter {
    
    var userSettings: UserSettings!
    weak var viewController: ISettingsScreenViewController!
    
    init(viewController: ISettingsScreenViewController) {
        self.viewController = viewController
        updateUserSettings()
    }
    
    private func updateUserSettings() {
        let userSettings = UserDefaultsManager.shared.featchUserSetting()
        self.userSettings = userSettings
    }
    
    func getProfileInfo() -> UserSettings {
        return userSettings
    }
    
    func savePhotoButtonTapped(image: UIImage) {
        if let fileURL = try! StorageManager().saveImage(image) {
            userSettings.photoUser = fileURL
            print(fileURL)
        }
        viewController.reloadData()
    }
    
    func updatePlayerNameButtonTapped(name: String) {
        userSettings.nameUser = name
        viewController.reloadData()
    }
    
    func changeCarButtonTapped() {
        userSettings.car.moveToNextCase()
        viewController.reloadData()
    }
    
    func changeLevelButton() {
        userSettings.lavel.moveToNextCase()
        viewController.reloadData()
    }
    
    func changeTypeButtonTapped() {
        userSettings.type.moveToNextCase()
        viewController.reloadData()
    }
    
    func saveUserSettings() {
        UserDefaultsManager.shared.saveUserSetting(data: userSettings)
    }
}
