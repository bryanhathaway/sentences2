//
//  PulsingImageView.swift
//  Boxes
//
//  Created by Bryan Hathaway on 11/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class PulsingImageView: UIView {
    let imageView = UIImageView()

    private let circle = CAShapeLayer()
    private let radius: CGFloat = 75

    override init(frame: CGRect) {
        super.init(frame: frame)


        let rect = CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius)
        circle.bounds = rect
        circle.path = UIBezierPath(roundedRect: rect,
                                   cornerRadius: radius).cgPath
        circle.fillColor = Theme.accent.cgColor
        layer.addSublayer(circle)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        let pulse = CABasicAnimation(keyPath: "transform.scale.xy")
        pulse.fromValue = 1.0
        pulse.toValue = 1.15
        pulse.duration = 0.75
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.isRemovedOnCompletion = false
        imageView.layer.add(pulse, forKey: "pulse")

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circle.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateAnimations()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAnimations() {
        let duration = 1.5

        let scale = CABasicAnimation(keyPath: "transform.scale.xy")
        scale.fromValue = 0.4
        scale.toValue = 2.0
        scale.duration = duration

        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.duration = duration
        opacity.values = [0.9, 0]

        let animations = [scale, opacity]
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = duration
        group.repeatCount = .infinity
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.isRemovedOnCompletion = false

        circle.removeAnimation(forKey: "group")
        circle.add(group, forKey: "group")
    }
}
