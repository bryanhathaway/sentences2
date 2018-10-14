//
//  SentenceEntryViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 4/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class SentenceEntryViewController: BlurredBackgroundViewController {
    private var sentence: Sentence
    private let sentenceView = SentenceCreatorView()
    private let paintButton = UIButton(type: .custom)

    var onCancel: (() -> ())?
    var completion: ((Sentence) -> ())?

    init(sentence: Sentence) {
        self.sentence = sentence
        super.init(nibName: nil, bundle: nil)

        preferredContentSize = CGSize(width: 600, height: 280)
        modalPresentationStyle = .formSheet
        title = "Create Sentence"
        backgroundImage = #imageLiteral(resourceName: "aurora3")

        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelItem

        let nextItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem = nextItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sentenceView.translatesAutoresizingMaskIntoConstraints = false
        sentenceView.titleTextField.text = sentence.title
        sentenceView.sentenceTextView.text = sentence.compiledSentence
        sentenceView.sideColor = sentence.color
        view.addSubview(sentenceView)

        paintButton.setBackgroundImage(#imageLiteral(resourceName: "button_paint").withRenderingMode(.alwaysTemplate), for: .normal)
        paintButton.tintColor = sentence.color
        paintButton.translatesAutoresizingMaskIntoConstraints = false
        paintButton.addTarget(self, action: #selector(paintTapped(_:)), for: .touchUpInside)
        view.addSubview(paintButton)

        let leadingConstraint = sentenceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0)
        let trailingConstraint = sentenceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        leadingConstraint.priority = .defaultHigh
        trailingConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            sentenceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            sentenceView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sentenceView.widthAnchor.constraint(lessThanOrEqualToConstant: 360.0),
            leadingConstraint,
            trailingConstraint,
            sentenceView.heightAnchor.constraint(equalToConstant: 170.0),

            paintButton.topAnchor.constraint(equalTo: sentenceView.bottomAnchor, constant: 8.0),
            paintButton.leadingAnchor.constraint(equalTo: sentenceView.leadingAnchor),
            paintButton.heightAnchor.constraint(equalToConstant: 22.0),
            paintButton.widthAnchor.constraint(equalTo: paintButton.heightAnchor)
            ])
    }

    @objc func cancelTapped() {
        sentenceView.endEditing(true)
        navigationController?.dismiss(animated: true)
        onCancel?()
    }

    @objc func nextTapped() {
        guard let title = sentenceView.titleTextField.text, title.count > 0 else { return }
        guard let sentenceText = sentenceView.sentenceTextView.text, sentenceText.count > 0 else { return }
        var phrases: [Phrase]

        // If compiled Sentence changed, then previous phrase data is overwritten.
        if sentence.compiledSentence != sentenceText {
            let words = LanguageProcessor.words(from: sentenceText)
            let nonSpaces = words.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

            phrases = nonSpaces.map { Phrase(value: $0) }

        } else {
            phrases = sentence.phrases
        }

        let editSentence = Sentence(title: title,
                                    compiledSentence: sentenceText,
                                    phrases: phrases,
                                    color: sentenceView.sideColor ?? Theme.accent)

        let controller = SentenceConstructorViewController(sentence: editSentence)
        controller.completion = completion
        show(controller, sender: nil)
    }

    @objc func paintTapped(_ sender: UIButton) {
        let controller = ColorPickerPopover()
        guard let popover = controller.popoverPresentationController else { return }
        popover.delegate = self
        popover.sourceRect = sender.bounds
        popover.sourceView = sender

        controller.onColorPicked = { [weak self, weak controller] color in
            self?.sentenceView.sideColor = color
            self?.paintButton.tintColor = color
            controller?.dismiss(animated: true, completion: nil)
        }

        present(controller, animated: true, completion: nil)
    }
}

extension SentenceEntryViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
