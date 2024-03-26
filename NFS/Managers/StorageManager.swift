//
//  StorageManager.swift
//  NFS
//
//  Created by Вячеслав on 6/3/24.
//

import Foundation
import UIKit

private enum Constants {
    static let compressionQuality = 1.0
    static let key = "userSettings"
    static let resultsKey = "userResults"
}

final class StorageManager {
    
    
    //MARK: - Public
    func saveImage(_ image: UIImage) throws -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask).first,
            let data = image.jpegData(compressionQuality: Constants.compressionQuality) else {
        return nil
        }
        let name = UUID().uuidString
        let url = directory.appendingPathComponent(name)
        try data.write(to: url)
        return name
}
    
    func loadImage(name: String) -> UIImage? {
        guard let directory = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask).first else {
        return nil
        }
        let url = directory.appendingPathComponent(name)
        let image = UIImage(contentsOfFile: url.path())
        return image
}
    
    func saveProfile(profile: UserSettings) {
        UserDefaultsManager().userSettings = profile
    }
    func saveResult(result: ResultModel) {
        
        var array = loadResults()
        
        if let index = array.firstIndex(where: { $0.playerName == result.playerName && ($0.score <= result.score || $0.score >= result.score)}) {
            array.remove(at: index)
            array.append(result)
        } else {
            array.append(result)
        }
        saveArray(array: array)
    }
    func loadResults()-> [ResultModel] {
        var data = [ResultModel]()
        if let result = UserDefaults.standard.object(forKey: Constants.resultsKey) as? Data {
            do {
                data = try JSONDecoder().decode([ResultModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    private func saveArray(array: [ResultModel]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: Constants.resultsKey)
        } catch {
            print(error)
        }
    }
    func deleteResult(result: ResultModel) {
        
        var array = loadResults()
        
        if let index = array.firstIndex(where: { $0.playerName == result.playerName }) {
            array.remove(at: index)
        }
        saveArray(array: array)
    }
}
