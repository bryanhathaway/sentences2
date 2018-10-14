//
//  FolderCreatorView.swift
//  Boxes
//
//  Created by Bryan Hathaway on 12/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class FolderCreatorView: UIView {

    private let sideView = UIView()
    var sideColor: UIColor? = Theme.accent {
        didSet {
            setThemeColor(sideColor)
        }
    }
    let titleTextField = UITextField()

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear

        let blur = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blur)

        layer.cornerRadius = 6.0
        clipsToBounds = true

        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)

        sideView.translatesAutoresizingMaskIntoConstraints = false
        sideView.alpha = 0.5
        addSubview(sideView)

        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        titleTextField.leftViewMode = .always
        titleTextField.leftView = spacerView
        titleTextField.keyboardAppearance = .dark
        titleTextField.backgroundColor = Theme.TextField.background
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.placeholder = "Title"
        titleTextField.autocapitalizationType = .words
        titleTextField.clipsToBounds = true
        titleTextField.textColor = Theme.Text.main
        titleTextField.returnKeyType = .next
        titleTextField.becomeFirstResponder()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleTextField)

        setThemeColor(Theme.accent)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),

            sideView.topAnchor.constraint(equalTo: topAnchor),
            sideView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sideView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sideView.widthAnchor.constraint(equalToConstant: 8.0),

            titleTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleTextField.leadingAnchor.constraint(equalTo: sideView.trailingAnchor, constant: 16.0),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            titleTextField.heightAnchor.constraint(equalToConstant: 40.0),
            titleTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setThemeColor(_ color: UIColor?) {
        sideView.backgroundColor = color
        titleTextField.tintColor = color
    }
}
