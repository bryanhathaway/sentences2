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

    private var boxes: [UIView] = []
    private var sentence: Sentence?
    private let canvas = UIView()
    private let engine: LayoutEngine

    var configuration: Configuration

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
            let boxView = self.box(for: phrase)
            boxView.layoutEngine = engine
            canvas.addSubview(boxView)
            boxView.frame.size = boxView.intrinsicContentSize // Has to be after adding to superview for layout reasons.

            return boxView
        }

        engine.distribute(views: boxes)

        self.boxes = boxes
    }

    private func box(for phrase: Phrase) -> Box {
        let box = Box(string: phrase.value)
        box.label.font = configuration.font(ofSize: box.label.font.pointSize)
        box.backgroundColor = phrase.color
        box.talkOnTouchBegan = configuration.isTapToSpeakEnabled
        return box
    }

    func clear() {
        boxes.forEach { $0.removeFromSuperview() }
    }

    @objc func shuffle() {
        engine.shuffle(views: boxes)
    }

    @objc func addTapped() {
        let box = ExpandableBox()
        box.backgroundColor = Theme.Box.background
        box.frame.size = box.intrinsicContentSize
        canvas.addSubview(box)
        box.center = canvas.center
        boxes.append(box)
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

