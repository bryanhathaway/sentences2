//
//  IconDetailCell.swift
//  Boxes
//
//  Created by Bryan Hathaway on 2/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class IconDetailCell: ShadowedTileCell {
    private static let imageSize: CGFloat = 40.0

    let titleLabel = UILabel()
    let detailLabel = UILabel()

    private let sideView = UIView()
    var sideColor: UIColor? {
        didSet {
            sideView.backgroundColor = sideColor
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        sideView.translatesAutoresizingMaskIntoConstraints = false
        sideView.alpha = 0.5
        tileView.addSubview(sideView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16.0)
        titleLabel.textColor = Theme.Text.main
        titleLabel.adjustsFontSizeToFitWidth = true
        tileView.addSubview(titleLabel)

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = .systemFont(ofSize: 12.0)
        detailLabel.textColor = Theme.Text.subtitle
        detailLabel.numberOfLines = 5
        tileView.addSubview(detailLabel)

        let bottomConstraint = detailLabel.bottomAnchor.constraint(equalTo: tileView.bottomAnchor, constant: -16.0)
        bottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            sideView.topAnchor.constraint(equalTo: tileView.topAnchor),
            sideView.leadingAnchor.constraint(equalTo: tileView.leadingAnchor),
            sideView.bottomAnchor.constraint(equalTo: tileView.bottomAnchor),
            sideView.widthAnchor.constraint(equalToConstant: 8.0),

            titleLabel.topAnchor.constraint(equalTo: tileView.topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: sideView.trailingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: tileView.trailingAnchor, constant: -16.0),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bottomConstraint
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
