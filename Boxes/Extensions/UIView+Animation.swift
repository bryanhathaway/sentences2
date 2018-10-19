//
//  UIView+Animation.swift
//  Boxes
//
//  Created by Bryan Hathaway on 3/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit
struct TimingOptions {
    let duration: TimeInterval
    let delay: TimeInterval
    let damping: CGFloat
    let spring: CGFloat

    static let `default` = TimingOptions(duration: 0.3, delay: 0.0, damping: 0.4, spring: 1.0)
}

extension UIView {
    typealias CompletionHandler = ((Bool) -> Void)

    func animateCenter(to center: CGPoint, options: TimingOptions = TimingOptions.default, completion: CompletionHandler? = nil) {

        animate(options: options, animations: {
            self.center = center
        }, completion: completion)
    }

    func animateOrigin(to origin: CGPoint, options: TimingOptions = TimingOptions.default, completion: CompletionHandler? = nil) {
        animate(options: options, animations: {
            self.frame.origin = origin
        }, completion: completion)
    }

    private func animate(options: TimingOptions = TimingOptions.default,
                         animations: @escaping (() -> ()),
                        completion: CompletionHandler? = nil) {
        UIView.animate(withDuration: options.duration,
                       delay: options.delay,
                       usingSpringWithDamping: options.damping,
                       initialSpringVelocity: options.spring,
                       options: [],
                       animations: animations,
                       completion: completion)
    }

    private static let wriggleKeyPos = "wriggleKeyPos"
    private static let wriggleKeyTransform = "wriggleKeyTransform"

    private func degreesToRadians(_ x: CGFloat) -> CGFloat {
        return .pi * x / 180.0
    }

    /*
     From Stack Overflow:
     https://stackoverflow.com/questions/6604356/ios-icon-jiggle-algorithm/47730519#47730519
     Authors:
     - Mientus: https://stackoverflow.com/users/733338/mientus
     - Paul Popiel: https://stackoverflow.com/users/5018607/paul-popiel
     */
    func startWiggle(duration: Double = 0.25, repeating: Bool = true, displacement: CGFloat = 1.0, degreesRotation: CGFloat = 2.0) {
        let negativeDisplacement = -1.0 * displacement
        let position = CAKeyframeAnimation.init(keyPath: "position")
        position.beginTime = 0.8
        position.duration = duration
        position.repeatCount = repeating ? Float.greatestFiniteMagnitude : 0.0
        position.values = [
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: 0, y: 0)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: 0)),
            NSValue(cgPoint: CGPoint(x: 0, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement))
        ]
        position.calculationMode = .linear
        position.isRemovedOnCompletion = false
        position.repeatCount = Float.greatestFiniteMagnitude
        position.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))
        position.isAdditive = true

        let transform = CAKeyframeAnimation.init(keyPath: "transform")
        transform.beginTime = 2.6
        transform.duration = duration
        transform.valueFunction = CAValueFunction(name: .rotateZ)
        transform.values = [
            degreesToRadians(-1.0 * degreesRotation),
            degreesToRadians(degreesRotation),
            degreesToRadians(-1.0 * degreesRotation)
        ]
        transform.calculationMode = .linear
        transform.isRemovedOnCompletion = false
        transform.repeatCount = Float.greatestFiniteMagnitude
        transform.isAdditive = true
        transform.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))

        self.layer.add(position, forKey: UIView.wriggleKeyPos)
        self.layer.add(transform, forKey: UIView.wriggleKeyTransform)
    }

    func stopWriggling() {
        self.layer.removeAnimation(forKey: UIView.wriggleKeyTransform)
        self.layer.removeAnimation(forKey: UIView.wriggleKeyPos)
    }
}
