//
//  GlassLabelCell.swift
//  Boxes
//
//  Created by Bryan Hathaway on 12/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class GlassLabelCell: GlassCell {
    let titleLabel = UILabel()
    fileprivate let subtitleLabel = UILabel()

    var subtitleText: String? {
        get {
            return subtitleLabel.text
        }
        set {
            subtitleLabel.text = newValue

            let hideSubtitle = newValue == nil
            subtitleLabel.isHidden = hideSubtitle
            titleBottom?.isActive = hideSubtitle
            subtitleBottom?.isActive = !hideSubtitle
        }
    }

    private var titleBottom: NSLayoutConstraint?
    private var subtitleBottom: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18.0)
        addSubview(titleLabel)

        subtitleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(subtitleLabel)

        let padding: CGFloat = 12.0
        titleBottom = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        subtitleBottom = subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.0),
            titleBottom!,

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subtitleText = nil
        titleLabel.text = nil
    }
}
