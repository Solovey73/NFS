//
//  SceneDelegate.swift
//  NFS
//
//  Created by Вячеслав on 12/2/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController:
                                                   StartScreenViewController())
        window?.makeKeyAndVisible()
    }
}

