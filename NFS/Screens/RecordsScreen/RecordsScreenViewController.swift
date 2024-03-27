//
//  RecordsScreenViewController.swift
//  NFS
//
//  Created by Вячеслав on 13/2/24.
//
import UIKit

private enum Constants {
    static let rowHeight: CGFloat = 100
    static let recordsTitle = "Рекорды"
}

final class RecordsScreenViewController: UITableViewController {

    private let presenter = RecordsListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        navigationItem.title = Constants.recordsTitle
        setUpPresenter()
    }
    
    private func setUpTable() {
        tableView.rowHeight = Constants.rowHeight
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
    }
    
    
    
    private func setUpPresenter() {
        presenter.setDelegate(delegate: self)
        presenter.getResults()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteResult(result: presenter.results[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as? PlayerTableViewCell else {return UITableViewCell()}
        cell.configure(result: presenter.results[indexPath.row])
        return cell
    }
}

extension RecordsScreenViewController: RecordsListPresenterDelegate {
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
