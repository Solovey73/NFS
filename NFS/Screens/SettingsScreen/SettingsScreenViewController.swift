//
//  SettingsScreenViewController.swift
//  NFS
//
//  Created by Вячеслав on 13/2/24.
//

import UIKit
private enum Constants {
    static let tableViewRowHeight: CGFloat = 100
    static let settingsTitle = "Настройки"
    static let countOfSettings = 4
}

protocol ISettingsScreenViewController: AnyObject {
    func reloadData()
}

class SettingsScreenViewController: UITableViewController {
    
    private var presenter: ISettingsScreenPresenter!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = SettingsScreenPresenter(viewController: self)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = Constants.tableViewRowHeight
        tableView.register(MyTableViewCell.self,
                           forCellReuseIdentifier: MyTableViewCell.identifier)
        navigationItem.title = Constants.settingsTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: showAlert()
        case 1: presenter.changeCarButtonTapped()
        case 2: presenter.changeLevelButton()
        case 3: presenter.changeTypeButtonTapped()
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.countOfSettings
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as? MyTableViewCell else {return UITableViewCell()}
        if indexPath.row == 0 {
            cell.configureProfileCell(profile: presenter.getProfileInfo())
        } else {
            cell.configure(profile: presenter.getProfileInfo(), index: indexPath.row)
        }
        return cell
    }
    
    
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Изменение ваших данных",
                                    message: "Вы хотите точно изменить данные?",
                                    preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Имя"
            textField.text = self.presenter.getProfileInfo().nameUser
        }
        let photoAction = UIAlertAction(title: "Выбрать фото", style: .default) { [weak self] _ in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self?.present(vc, animated: true)
        }
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            if let name = alertController.textFields![0].text {
                if !name.isEmpty {
                    self?.presenter.updatePlayerNameButtonTapped(name: name)
                }
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        alertController.addAction(photoAction)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    deinit {
        presenter.saveUserSettings()
    }
}

extension SettingsScreenViewController: ISettingsScreenViewController {
    func reloadData() {
        tableView.reloadData()
    }
}

extension SettingsScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        presenter.savePhotoButtonTapped(image: image)
        self.dismiss(animated: true)
    }
}
