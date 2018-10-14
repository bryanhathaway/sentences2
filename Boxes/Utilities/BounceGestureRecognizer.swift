//
//  BounceGestureRecognizer.swift
//  Boxes
//
//  Created by Bryan Hathaway on 3/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

/// A gesture recognizer that scales its view based on the force of the touch (on 3D Touch devices). Non-3D Touch devices will scale the view to a fixed size when touched.
class BounceGestureRecognizer: UIGestureRecognizer {
    var hapticEngine: UIImpactFeedbackGenerator?
    var initialFrame: CGRect?

    var scale: CGFloat
    var forceMultiplier: CGFloat
    var initialTapForce: CGFloat

    var hasReachedThreshold = false
    private var touchDate: Date?

    init(scale: CGFloat = 0.95, forceMultiplier: CGFloat = 1.5, initialTapForce: CGFloat  = 0.1) {
        self.scale = scale
        self.forceMultiplier = forceMultiplier
        self.initialTapForce = initialTapForce

        super.init(target: nil, action: nil)

        delaysTouchesBegan = false
        delaysTouchesEnded = false
        cancelsTouchesInView = false

        hapticEngine = UIImpactFeedbackGenerator(style: .light)
        hapticEngine?.prepare()
        delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }
        initialFrame = view?.frame
        hasReachedThreshold = false
        hapticEngine?.impactOccurred()
        hapticEngine?.prepare()
        touchDate = Date()

        scaleButton(touch: touch, animated: true)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first else { return }

        guard (initialFrame ?? CGRect.zero).contains(touch.location(in: view?.superview)) else {
            deflateButton()
            return
        }

        scaleButton(touch: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        // Prevent from double firing on a regular tap
        if touchDate?.timeIntervalSinceNow ?? 0 <= -0.05 {
            hapticEngine?.impactOccurred()
            hapticEngine?.prepare()
        }

        deflateButton()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        deflateButton()
    }

    // Mark: - Scaling
    private func scaleButton(touch: UITouch, animated: Bool = false) {
        guard UIAccessibility.isReduceMotionEnabled == false else { return }
        guard let initialFrame = initialFrame else { return }

        var force = (touch.force / touch.maximumPossibleForce) + initialTapForce
        if force.isNaN {
            force = 0.1
        }

        let calculatedScale = 1 + ((initialFrame.width * scale) / initialFrame.width - 1) * force * forceMultiplier

        if animated {
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                self.view?.transform = CGAffineTransform(scaleX: calculatedScale, y: calculatedScale)
            }, completion: nil)

        } else {
            view?.transform = CGAffineTransform(scaleX: calculatedScale, y: calculatedScale)
        }
    }

    private func deflateButton(delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
            self.view?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}

extension BounceGestureRecognizer: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
