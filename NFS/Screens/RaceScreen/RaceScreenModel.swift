//
//  RaceScreenModel.swift
//  NFS
//
//  Created by Вячеслав on 26/2/24.
//

import Foundation
private extension String {
    static let dateFormat = "dd.MM.yyyy"
    static let hourFormat = "HH:mm"
}
struct ResultModel: Codable {
    let playerName: String
    let image: String
    let score: Int
    let date: String
    let time: String
}
class DateManager {
    
    private let formatter = DateFormatter()
    
    func getCurrentDate()-> String {
        let date = Date()
        formatter.dateFormat = String.dateFormat
        return formatter.string(from: date)
    }
    
    func getCurrentTime()-> String {
        let date = Date()
        formatter.dateFormat = String.hourFormat
        return formatter.string(from: date)
    }
}
