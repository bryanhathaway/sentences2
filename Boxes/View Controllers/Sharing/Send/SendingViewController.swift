//
//  SendingViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 10/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class SendingViewController: BlurredBackgroundViewController {
    let sender: MultipeerSender
    var done: (() -> ())?

    init(transportData: TransportData) {
        sender = MultipeerSender(transportData: transportData)

        super.init(nibName: nil, bundle: nil)

        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let pulseView = PulsingImageView()
        pulseView.imageView.image = #imageLiteral(resourceName: "folder_closed")
        pulseView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pulseView)

        NSLayoutConstraint.activate([
            pulseView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pulseView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            pulseView.heightAnchor.constraint(equalToConstant: 125),
            pulseView.widthAnchor.constraint(equalToConstant: 125),
            ])
    }

    @objc func doneTapped() {
        done?()
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
