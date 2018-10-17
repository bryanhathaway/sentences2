//
//  ConfigurationOption.swift
//  Boxes
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsConfigurableCell {
    var titleLabel: UILabel { get }
    var subtitleLabel: UILabel { get }
}

class ConfigurationOption {
    let title: String
    let subtitle: String
    class var reuseIdentifier: String {
        return "OptionCell"
    }

    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }

    func configure(cell: SettingsConfigurableCell) {
        cell.titleLabel.text = title
        cell.subtitleLabel.text = subtitle
    }
}

class SwitchOption: ConfigurationOption {
    var getter: (() -> (Bool))?
    var setter: ((Bool) -> ())?

    override class var reuseIdentifier: String {
        return "SwitchCell"
    }

    override func configure(cell: SettingsConfigurableCell) {
        super.configure(cell: cell)
        guard let cell = cell as? GlassSwitchCell else { return }

        cell.switchView.tintColor = Theme.accent
        cell.switchView.onTintColor = Theme.accent

        cell.switchView.isOn = getter?() ?? false

        cell.valueChanged = { [weak self] selected in
            self?.setter?(selected)
        }

    }
}
