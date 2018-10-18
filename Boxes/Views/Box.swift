//
//  Box.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import UIKit

/// BoxHapticEngine is a private haptic engine shared between all instances of Box.
fileprivate class BoxHapticEngine {
    static let shared = BoxHapticEngine()

    private let engine = UIImpactFeedbackGenerator(style: .light)

    func prepare() {
        engine.prepare()
    }

    func impact() {
        engine.impactOccurred()
    }
}

class Box: UIView {
    static let compactFontSize: CGFloat = 25.0
    static let regularFontSize: CGFloat = 40.0

    let label = UILabel()
    private let backgroundView = UIView()

    private let verticalPadding: CGFloat
    private let horizontalPadding: CGFloat

    weak var layoutEngine: LayoutEngine?

    var talkOnTouchBegan: Bool = false

    override var backgroundColor: UIColor? {
        get {
            return backgroundView.backgroundColor
        }
        set {
            backgroundView.backgroundColor = newValue
        }
    }

    init(string: String) {
        let isNonWord = string.trimmingCharacters(in: .punctuationCharacters).trimmingCharacters(in: .whitespaces).isEmpty
        verticalPadding = 8.0
        horizontalPadding = isNonWord ? 1.0 : 6.0

        super.init(frame: .zero)

        let blur = UIBlurEffect(style: Theme.Box.blurStyle)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 1.0
        addSubview(blurView)

        backgroundView.backgroundColor = Theme.Box.background
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.alpha = 0.7
        addSubview(backgroundView)

        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 0.0

        label.text = string
        label.font = UIFont.systemFont(ofSize: Box.compactFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Theme.Box.text
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            ])

        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)

        BoxHapticEngine.shared.prepare()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let isCompactWidth = traitCollection.horizontalSizeClass == .compact
        let size = isCompactWidth ? Box.compactFontSize : Box.regularFontSize
        label.font = UIFont(name: label.font.fontName, size: size)

        invalidateIntrinsicContentSize()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

    }

    override var intrinsicContentSize: CGSize {
        var size = label.intrinsicContentSize
        size.width += horizontalPadding * 2.0
        size.height += verticalPadding * 2.0
        return size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Touch Interaction

    /// Tracks the center as it was at the start of the pan
    private var centerOrigin: CGPoint?

    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            centerOrigin = center
            animate(scaleUp: true)

        case .changed:
            if transform.isIdentity {
                animate(scaleUp: true)
            }
            guard let origin = centerOrigin else { return }
            let trans = sender.translation(in: superview)
            center = CGPoint(x: origin.x + trans.x, y: origin.y + trans.y)

        case .cancelled: fallthrough
        case .ended:
            layoutEngine?.snap(view: self)
            centerOrigin = nil
            animate(scaleUp: false)

        default: break
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // This logic is done here to give a more responsive feel
        // as touchesBegan can fire without the PanGesture firing.
        superview?.bringSubviewToFront(self)

        animate(scaleUp: true)

        BoxHapticEngine.shared.impact()
        BoxHapticEngine.shared.prepare()

        if talkOnTouchBegan, let string = label.text {
            DispatchQueue.main.async {
                TextToSpeech.shared.speak(text: string.lowercased())
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // To handle cases of the touch ending when no pan ocurred.
        animate(scaleUp: false)

    }

    // MARK: - Animation

    /// Animates the scale and shadow of a box to make it appear lifted above its siblings.
    private func animate(scaleUp: Bool) {
        let scale: CGFloat = scaleUp ? 1.1 : 1.0
        let radius: CGFloat = scaleUp ? 7.0 : 0.0
        let opacity: Float = scaleUp ? 0.7 : 0.0

        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.layer.shadowRadius = radius
            self.layer.shadowOpacity = opacity
        }, completion: nil)
    }

}

extension Box: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
