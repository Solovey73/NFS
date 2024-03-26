//
//  RecordsScreenPresenter.swift
//  NFS
//
//  Created by Вячеслав on 26/2/24.
//

import Foundation

protocol RecordsListPresenterDelegate: AnyObject {
    func reloadData()
}

class RecordsListPresenter {
    
    weak var delegate: RecordsListPresenterDelegate?
    
    private let dataStorageManager = StorageManager()
    //private let settingsManager = SettingsManager()
    
    var results = [ResultModel]()
    
    func setDelegate(delegate: RecordsListPresenterDelegate) {
        self.delegate = delegate
    }
    
    func getResults() {
        results = dataStorageManager.loadResults().sorted { $0.score > $1.score }
        delegate?.reloadData()
    }
    
    func deleteResult(result: ResultModel) {
        dataStorageManager.deleteResult(result: result)
        getResults()
    }
}

