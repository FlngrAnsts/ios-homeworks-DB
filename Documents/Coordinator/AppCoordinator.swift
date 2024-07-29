//
//  AppCoordinator.swift
//  Documents
//
//  Created by Anastasiya on 29.07.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    var rootViewCOntroller: UIViewController;
    let window:UIWindow
    
    init(windows: UIWindow) {
        self.rootViewCOntroller = UIViewController()
        self.window = windows
        let store  = KeychainStore()
        
        var step: Step = .passwordCreated
        if (store.load() == "") {
            step = .creatPassword
        }
    
        let loginViewController = LogInViewController(store: store, step: step, routeToMaint: routeToMaint)
       
        
        self.rootViewCOntroller = UINavigationController(rootViewController: loginViewController)
    }
    
    func routeToMaint(){
        let tabBarController =  UITabBarController()
        let viewController = MainTableViewController()
        let settingsViewController = SettingsViewController(updateTable: viewController.updateTable)
        settingsViewController.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 0)
        viewController.tabBarItem = UITabBarItem(title: "Папки", image: UIImage(systemName: "folder"), tag: 1)
        let controllers = [settingsViewController, viewController]
        tabBarController.viewControllers = controllers
        tabBarController.selectedIndex = 0
        UITabBar.appearance().backgroundColor = .white
        rootViewCOntroller = tabBarController
        window.switchRootViewController(tabBarController)
    }
    
}

extension UIWindow {
    
    func switchRootViewController(_ viewController: UIViewController,  animated: Bool = true, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .transitionFlipFromRight, completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
