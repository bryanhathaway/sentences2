//
//  ConfettiImageView.swift
//  Boxes
//
//  Created by Bryan Hathaway on 11/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class ConfettiImageView: UIView {
    let imageView = UIImageView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        label.font = .systemFont(ofSize: 14.0)
        label.textColor = Theme.accent
        label.text = "Folders Received"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        imageView.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12.0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func playAnimation() {
        let scale: CGFloat = 0.7

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: scale, y: scale)

        }) { _ in
            self.startPopImageAnimation()
        }
    }

    private func startPopImageAnimation() {

        let emitter = self.addConfettiLayer()
        layoutIfNeeded()

        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: [], animations: {
            self.imageView.transform = .identity
            self.label.alpha = 1.0

            emitter.velocity = 1.0
            emitter.birthRate = 1.0

        }, completion: nil)
    }

    private func addConfettiLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterMode = .volume
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.velocity = 10.0
        emitterLayer.birthRate = 10.0
        var size = frame.size
        size.width /= 4
        size.height /= 4
        emitterLayer.emitterSize = size

        emitterLayer.emitterCells = [#colorLiteral(red: 0.6470588235, green: 0.368627451, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 0.2941176471, green: 0.4823529412, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.2705882353, green: 0.6666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.05882352941, green: 0.7254901961, blue: 0.6941176471, alpha: 1), #colorLiteral(red: 0.1254901961, green: 0.7490196078, blue: 0.4196078431, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.7176470588, blue: 0.1921568627, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.5098039216, blue: 0.1921568627, alpha: 1), #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0.3529411765, alpha: 1)].map { emitterCell(color: $0) }
        layer.insertSublayer(emitterLayer, below: imageView.layer)

        return emitterLayer
    }

    private func emitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()

        cell.birthRate = 9.0
        cell.lifetime = 14.0
        cell.lifetimeRange = 1.0

        cell.velocity = 300.0
        cell.velocityRange = 70.0
        cell.yAcceleration = 350

        cell.emissionLongitude = CGFloat(Double.pi)
        cell.emissionRange = CGFloat(Double.pi)

        cell.spin = 3.0
        cell.spinRange = 5.0

        cell.scaleRange = 1.0
        cell.scaleSpeed = -0.1

        cell.contents = #imageLiteral(resourceName: "confetti.png").cgImage
        cell.color = color.cgColor

        return cell
    }
}
