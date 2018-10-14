//
//  ShadowedTileCell.swift
//  Boxes
//
//  Created by Bryan Hathaway on 2/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit
class ShadowedTileCell: UITableViewCell {

    let tileView: UIView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let blur = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blur)


        tileView = blurView.contentView

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        selectionStyle = .none

        blurView.layer.cornerRadius = 6.0
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        addSubview(blurView)

        blurView.addGestureRecognizer(BounceGestureRecognizer())


        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor, constant: 6.0),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.0),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
