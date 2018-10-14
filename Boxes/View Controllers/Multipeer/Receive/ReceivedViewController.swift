//
//  ReceivedViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 11/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class ReceivedViewController: BlurredBackgroundViewController {
    var completion: ((TransportData) -> ())?
    private let transportData: TransportData
    private let confettiView = ConfettiImageView()

    init(transportData: TransportData) {
        self.transportData = transportData

        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        confettiView.imageView.image = #imageLiteral(resourceName: "folder_open")
        confettiView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confettiView)

        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),

            confettiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confettiView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            confettiView.heightAnchor.constraint(equalToConstant: 125),
            confettiView.widthAnchor.constraint(equalToConstant: 125),
            ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confettiView.playAnimation()
    }

    @objc func doneTapped() {
        completion?(transportData)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
