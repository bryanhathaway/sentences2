//
//  GlassCell.swift
//  Boxes
//
//  Created by Bryan Hathaway on 10/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class GlassCell: UITableViewCell {
    let vibrancyView: UIVisualEffectView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        let vibrancy = UIVibrancyEffect(blurEffect: blur)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        self.vibrancyView = vibrancyView

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)

        blurView.contentView.addSubview(vibrancyView)
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(separator)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),

            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.heightAnchor.constraint(equalToConstant: UIScreen.main.scale / 3.0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryView = nil
    }
}



