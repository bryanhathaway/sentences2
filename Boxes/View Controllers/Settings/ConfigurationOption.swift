//
//  ConfigurationOption.swift
//  Boxes
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

protocol TitleConfigurableCell {
    var titleLabel: UILabel { get }
}

protocol SubtitleConfigurableCell {
    var subtitleLabel: UILabel { get }
}

class ConfigurationOption {
    let title: String
    let subtitle: String?
    class var reuseIdentifier: String {
        return "OptionCell"
    }

    init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }

    func configure(cell: UITableViewCell) {
        if let cell = cell as? TitleConfigurableCell {
            cell.titleLabel.text = title
        }
        if let cell = cell as? SubtitleConfigurableCell {
            cell.subtitleLabel.text = subtitle
        }
    }
}

class SwitchOption: ConfigurationOption {
    override class var reuseIdentifier: String {
        return "SwitchCell"
    }

    var getter: (() -> (Bool))?
    var setter: ((Bool) -> ())?

    override func configure(cell: UITableViewCell) {
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

class SelectableOption: ConfigurationOption {
    override class var reuseIdentifier: String {
        return "ChevronCell"
    }

    typealias SelectionHandler = (() -> ())
    var onSelection: SelectionHandler

    init(title: String, onSelection: @escaping SelectionHandler) {
        self.onSelection = onSelection
        super.init(title: title, subtitle: nil)

    }
}


extension GlassSwitchCell: TitleConfigurableCell, SubtitleConfigurableCell { }
extension GlassChevronCell: TitleConfigurableCell { }
