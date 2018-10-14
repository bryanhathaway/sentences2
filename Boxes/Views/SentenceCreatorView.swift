//
//  SentenceCreatorView.swift
//  Boxes
//
//  Created by Bryan Hathaway on 4/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class SentenceCreatorView: UIView {

    private let sideView = UIView()
    var sideColor: UIColor? = Theme.accent {
        didSet {
            setThemeColor(sideColor)
        }
    }

    let titleTextField = UITextField()
    let sentenceTextView = UITextView()


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
        titleTextField.delegate = self
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleTextField)

        sentenceTextView.text = SentenceCreatorView.placeholderText
        sentenceTextView.textColor = Theme.TextField.placeholder
        sentenceTextView.delegate = self
        sentenceTextView.keyboardAppearance = .dark
        sentenceTextView.backgroundColor = Theme.TextField.background
        sentenceTextView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sentenceTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sentenceTextView)

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

            sentenceTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4.0),
            sentenceTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            sentenceTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            sentenceTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setThemeColor(_ color: UIColor?) {
        sideView.backgroundColor = color
        titleTextField.tintColor = color
        sentenceTextView.tintColor = color
    }
}

extension SentenceCreatorView: UITextViewDelegate {
    static let placeholderText = "Sentence"

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        sentenceTextView.textColor = Theme.Text.subtitle

        if(sentenceTextView.text == SentenceCreatorView.placeholderText) {
            sentenceTextView.text = nil
        }

        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if(sentenceTextView.text.isEmpty) {
            sentenceTextView.text = SentenceCreatorView.placeholderText
            sentenceTextView.textColor = Theme.TextField.placeholder
        }
    }
}

extension SentenceCreatorView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sentenceTextView.becomeFirstResponder()
        return false
    }
}
