//
//  SettingsViewController.swift
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

class SettingsViewController: GlassTableViewController {
    private let reuseIdentifier = "Cell"
    private let configuration: Configuration
    private var options: [ConfigurationOption] = []

    init(configuration: Configuration) {
        self.configuration = configuration

        super.init(style: .grouped)

        title = "Settings"

        tableView.register(GlassSwitchCell.self, forCellReuseIdentifier: reuseIdentifier)

        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func cancelTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GlassSwitchCell.self, forCellReuseIdentifier: SwitchOption.reuseIdentifier)

        options = generateOptions()
    }

    func generateOptions() -> [ConfigurationOption] {
        let fontOption = SwitchOption(title: "OpenDyslexic font",
                                      subtitle: "OpenDyslexic will be used as the font for boxes and the folder/sentence lists.")
        fontOption.getter = {
            return true
            //            return self.configuration.font
        }
        fontOption.setter = { isOn in
            self.configuration.font = .systemFont(ofSize: 16.0)
        }

        let speakOption = SwitchOption(title: "Tap to Speak",
                                       subtitle: "Words will be spoken aloud when a box is tapped.")
        speakOption.getter = {
            return self.configuration.isTapToSpeakEnabled
        }
        speakOption.setter = { isOn in
            self.configuration.isTapToSpeakEnabled = isOn
        }

        return [fontOption, speakOption]
    }


    // MARK: - Delegate / Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let identifier = type(of: option).reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        option.configure(cell: cell as! SettingsConfigurableCell)

        // This isn't ideal, but it's good enough for now
        cell.layoutIfNeeded()

        return cell
    }
}
