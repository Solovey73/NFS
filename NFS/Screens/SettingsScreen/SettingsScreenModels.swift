//
//  SettingsScreenModels.swift
//  NFS
//
//  Created by Вячеслав on 26/2/24.
//

import Foundation
import UIKit



struct UserSettings: Codable {
    
    var nameUser: String
    
    var photoUser: String
    
    var car: Car
    
    var lavel: GameDifficultyLevel

    var type: TypeControl
}

enum GameDifficultyLevel: Codable {
    case easy
    case middle
    case hard
    
    mutating func moveToNextCase() {
        switch self {
        case .easy:
            self = .middle
        case .middle:
            self = .hard
        case .hard:
            self = .easy
        }
    }
    
    var GameDifficultyLevelString: String {
        switch self {
        case .easy : return "легко"
        case .middle: return "средне"
        case .hard: return "сложно"
        }
    }
}

enum TypeControl: Codable {
    case tap
    case swipe
    case accelerometer
    
    mutating func moveToNextCase() {
        switch self {
        case .tap:
            self = .swipe
        case .swipe:
            self = .accelerometer
        case .accelerometer:
            self = .tap
        }
    }
    
    var TypeControlString: String {
        switch self {
        case .tap : return "tap"
        case .swipe: return "swipe"
        case .accelerometer: return "acselerometr"
        }
    }

}

enum Car: Codable {
    case red
    case green
    case blue
    
    mutating func moveToNextCase() {
        switch self {
        case .red:
            self = .green
        case .green:
            self = .blue
        case .blue:
            self = .red
        }
    }
    
    var CarString: String {
        switch self {
        case .red : return "Ferrari F40"
        case .green: return "Mazda 626 MPS"
        case .blue: return "99' Lamborghini Diablo"
        }
    }
}
