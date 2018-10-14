//
//  BlurredBackgroundViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 4/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class BlurredBackgroundViewController: UIViewController {

    var backgroundImage: UIImage = #imageLiteral(resourceName: "background")
    var blurStyle: UIBlurEffect.Style = .regular

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 1.0
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
