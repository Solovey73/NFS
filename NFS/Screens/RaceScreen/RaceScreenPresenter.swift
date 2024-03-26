//
//  RaceScreenPresenter.swift
//  NFS
//
//  Created by Вячеслав on 26/2/24.
//

import Foundation

protocol IRaceScreenPresenter {
    func loadUserSettingsFromMemory()
    func saveResult(score: Int)
}
final class RaceScreenPresenter {
    private var userSettings:UserSettings!
    weak var viewController: IRaceScreenViewController!
    init(viewController: IRaceScreenViewController) {
        self.viewController = viewController
    }
    func loadUserSettingsFromMemory() {
        let userSettings = UserDefaultsManager.shared.featchUserSetting()
        viewController.userSettings = userSettings
        self.userSettings = userSettings
    }
    func saveResult(score: Int) {
        let resultModel = ResultModel(playerName: userSettings.nameUser, image: userSettings.photoUser, score: score, date: DateManager().getCurrentDate(), time: DateManager().getCurrentTime())
        StorageManager().saveResult(result: resultModel)
    }
}

extension RaceScreenPresenter: IRaceScreenPresenter {
    
}
