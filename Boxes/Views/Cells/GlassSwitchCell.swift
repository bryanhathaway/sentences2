//
//  GlassSwitchCell.swift
//  Boxes
//
//  Created by Bryan Hathaway on 12/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class GlassSwitchCell: GlassCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    var valueChanged: ((Bool) -> ())?
    let switchView = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18.0)
        addSubview(titleLabel)

        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(subtitleLabel)

        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(switchView)

        let padding: CGFloat = 12.0
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: switchView.leadingAnchor, constant: -16.0),

            switchView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func switchChanged(_ sender: UISwitch) {
        valueChanged?(sender.isOn)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subtitleLabel.text = nil
        titleLabel.text = nil
    }
}

extension GlassSwitchCell: SettingsConfigurableCell { }
