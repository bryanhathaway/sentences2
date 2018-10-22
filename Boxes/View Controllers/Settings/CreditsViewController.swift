//
//  CreditsViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 18/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class CreditsViewController: BlurredBackgroundViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        blurStyle = .dark
        title = "Credits"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {

        super.viewDidLoad()

        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = Theme.accent
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 16.0)
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.alwaysBounceVertical = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInset = UIEdgeInsets(top: 32.0, left: 16.0, bottom: 32.0, right: 16.0)
        view.addSubview(textView)

        var string = "This project is open sourced on GitHub\nwww.github.com/bryanhathaway/sentences2"
        string += "\n\n"
        string += "Icons by Icons8\nwww.icons8.com"
        textView.text = string

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
}
