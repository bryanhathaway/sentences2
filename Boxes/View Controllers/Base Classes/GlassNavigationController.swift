//
//  GlassNavigationController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 4/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class GlassNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        navigationBar.barTintColor = .clear
        navigationBar.isTranslucent = true
        navigationBar.tintColor = Theme.accent
        navigationBar.titleTextAttributes = [.foregroundColor: Theme.accent]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.isUserInteractionEnabled = false
        blurView.layer.zPosition = -1
        blurView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(blurView)
        // I'm pretty sure adding it to the navigationBar like this
        // should be considered "illegal".

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            ])
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
