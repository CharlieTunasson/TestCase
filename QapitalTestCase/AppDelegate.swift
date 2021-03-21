//
//  AppDelegate.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupNavigationBarAppearance()

        let activityViewController = ActivityViewController(viewModel: ActivityViewModel())
        let navigationController = UINavigationController(rootViewController: activityViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    func setupNavigationBarAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.appFont(placement: .titleA),
                                                            NSAttributedString.Key.foregroundColor: UIColor.title]
        UINavigationBar.appearance().barTintColor = .background
        UINavigationBar.appearance().tintColor = .title
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for:.default)
    }
}
