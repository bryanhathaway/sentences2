//
//  AppDelegate.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let splitViewController = UISplitViewController()

        let detailController = DetailViewController()
        detailController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        let detailNav = GlassNavigationController(rootViewController: detailController)

        let masterController = FoldersViewController()
        let masterNav = GlassNavigationController(rootViewController: masterController)

        splitViewController.viewControllers = [masterNav, detailNav]
        splitViewController.preferredDisplayMode = .primaryOverlay
        splitViewController.delegate = self
        splitViewController.presentsWithGesture = false

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()

        return true
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

