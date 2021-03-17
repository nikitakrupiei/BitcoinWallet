//
//  AppDelegate.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setInitialScreen()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Application.shared.getBitcoinRate()
    }
}

extension AppDelegate {
    func setInitialScreen(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        let mainView = WalletViewController()
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
    }
}

