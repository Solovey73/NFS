//
//  UserDefaultsManager.swift
//  NFS
//
//  Created by Вячеслав on 20/3/24.
//

import Foundation

import UIKit

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    func saveUserSetting(data: UserSettings) {
        
        if  let dataSetting = try? PropertyListEncoder().encode(data) {
            defaults.set(dataSetting, forKey: "UserSetting")
        }
    }
    
    func featchUserSetting() -> UserSettings {
        
        guard let data = defaults.value(forKey: "UserSetting") as? Data,
              let model = try? PropertyListDecoder().decode(UserSettings.self, from: data) else {
            return createStartSetting()
        }
        return model
    }
    
//    func saveResultGame(_ data: ModelResultGame)  {
//        
//        var results = featchResultGame()
//        
//        results.append(data)
//        
//        if  let dataSetting = try? PropertyListEncoder().encode(results) {
//            defaults.set(dataSetting, forKey: "ResultGame")
//        }
//    }
    
//    func featchResultGame() -> [ModelResultGame] {
//        
//        guard let data = defaults.value(forKey: "ResultGame") as? Data,
//              let model = try? PropertyListDecoder().decode([ModelResultGame].self, from: data) else {
//            return []
//        }
//        return model
//    }
    
    func createStartSetting() -> UserSettings {
        
        UserSettings(nameUser: "Test", photoUser: "AppIcon", car: .red, lavel: .easy, type: .swipe)
    }
    
    func firstLaunch() {
        let settingForGame = createStartSetting()
        self.saveUserSetting(data: settingForGame)
    }
    
    func propertyListValue<Value: Decodable>(forKey key: String) -> Value? {
        guard let data = defaults.value(forKey: key) as? Data,
              let value = try? PropertyListDecoder().decode(Value.self, from: data)
        else {
            return nil
        }
        return value
    }
}

extension UserDefaultsManager {
    
    var userSettings: UserSettings {
        get {
            guard let value: UserSettings = propertyListValue(forKey: "UserSetting") else {
                return createStartSetting()
            }
            return value
        }
        set {
            guard let dataSetting = try? PropertyListEncoder().encode(newValue) else {
                return
            }
            defaults.set(dataSetting, forKey: "UserSetting")
        }
    }
}
