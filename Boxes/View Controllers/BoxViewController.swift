//
//  BoxViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import UIKit
import AVFoundation

class BoxViewController: BlurredBackgroundViewController {

    private var boxes: [Box] = []
    private var sentence: Sentence?
    private let canvas = UIView()
    private let engine: LayoutEngine

    var configuration: Configuration {
        didSet {
            boxes.forEach { box in
                box.talkOnTouchBegan = configuration.isTapToSpeakEnabled
                box.label.font = configuration.font(ofSize: box.label.font.pointSize)
                box.label.invalidateIntrinsicContentSize()
                box.frame.size = box.intrinsicContentSize
            }
        }
    }

    init(configuration: Configuration) {
        self.configuration = configuration

        engine = LayoutEngine(canvas: canvas)

        super.init(nibName: nil, bundle: nil)

        let shuffleItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_shuffle"), style: .plain, target: self, action: #selector(shuffle))
        let speakItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_microphone"), style: .plain, target: self, action: #selector(speakTapped(_:)))
        let addBoxItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_add_box"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [shuffleItem, speakItem, addBoxItem]

        backgroundImage = #imageLiteral(resourceName: "aurora1")
        blurStyle = .dark
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var isFirstLayout = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard isFirstLayout else { return }
        isFirstLayout = false
        engine.distribute(views: boxes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.backgroundColor = Theme.background
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        splitViewController?.presentsWithGesture = false

        canvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvas)

        NSLayoutConstraint.activate([
            canvas.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            canvas.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            canvas.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            canvas.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            ])
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.left]
    }

    func setSentence(_ sentence: Sentence) {
        clear()
        self.sentence = sentence

        let nonSpaces = sentence.phrases.filter { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }


        let boxes = nonSpaces.map { phrase -> Box in
            let box = self.box(for: phrase)
            return box
        }

        engine.distribute(views: boxes)

        self.boxes = boxes
    }

    private func box(for phrase: Phrase) -> Box {
        let box = self.box(for: phrase.value)
        box.backgroundColor = phrase.color
        return box
    }

    private func box(for text: String?) -> Box {
        var box: Box
        if let text = text, text.count > 0 {
            box = Box(string: text)
            box.talkOnTouchBegan = configuration.isTapToSpeakEnabled

        } else {
            box = ExpandableBox()
        }

        box.label.font = configuration.font(ofSize: box.label.font.pointSize)
        box.backgroundColor = Theme.Box.background
        box.frame.size = box.intrinsicContentSize

        box.onLongHold = { [unowned self] box in
            self.showColorPicker(for: box)
        }

        configure(box: box, for: engine)

        return box
    }

    private func configure(box: Box, for engine: LayoutEngine) {
        box.layoutEngine = engine
        engine.canvas.addSubview(box)
        box.frame.size = box.intrinsicContentSize
    }

    private func addExtraBox(text: String?) {
        let box = self.box(for: text)
        box.center = canvas.center
        boxes.append(box)

        view.layoutIfNeeded()
        box.alpha = 0.0
        box.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        box.setShadow(enabled: true)

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            box.transform = CGAffineTransform.identity
            box.alpha = 1.0
            box.setShadow(enabled: false)
        }, completion: nil)
    }

    private func showColorPicker(for box: Box) {
        let controller = ColorPickerPopover()
        guard let popover = controller.popoverPresentationController else { return }
        popover.delegate = self
        popover.sourceRect = box.bounds
        popover.sourceView = box

        controller.onColorPicked = { [weak box, weak controller] color in
            box?.backgroundColor = color
            controller?.dismiss(animated: true, completion: nil)
        }

        present(controller, animated: true, completion: nil)
    }

    func clear() {
        boxes.forEach { $0.removeFromSuperview() }
    }

    @objc func shuffle() {
        boxes.forEach { $0.set(transparent: false) }
        engine.shuffle(views: boxes)
    }

    @objc func addTapped() {
        let controller = UIAlertController(title: "New Box", message: "What should be displayed in the box?", preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "Create", style: .default, handler: { [unowned self] _ in
            let text = controller.textFields?.first?.text
            self.addExtraBox(text: text)
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(controller, animated: true, completion: nil)
    }

    // MARK: - Text to Speech

    @objc func speakTapped(_ sender: UIBarButtonItem) {
        guard !TextToSpeech.shared.isSpeaking else {
            TextToSpeech.shared.stop()
            return
        }

        guard let sentence = sentence else { return }

        sender.image = #imageLiteral(resourceName: "icon_stop")

        TextToSpeech.shared.speak(text: sentence.compiledSentence) {
             sender.image = #imageLiteral(resourceName: "icon_microphone")
        }

    }
}

extension BoxViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
