//
//  SettingsViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 17/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: GlassTableViewController {
    private let configuration: Configuration
    private var options: [[ConfigurationOption]] = [[]]

    init(configuration: Configuration) {
        self.configuration = configuration

        super.init(style: .grouped)

        title = "Settings"

        let cancelItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(cancelTapped))
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
        tableView.register(GlassChevronCell.self, forCellReuseIdentifier: SelectableOption.reuseIdentifier)

        options = generateOptions()
    }

    func generateOptions() -> [[ConfigurationOption]] {
        // Font
        let fontOption = SwitchOption(title: "OpenDyslexic font",
                                      subtitle: "OpenDyslexic will be used as the font for boxes and the folder/sentence lists.")
        fontOption.getter = { [unowned self] in
            return self.configuration.font == .openDyslexic
        }
        fontOption.setter = {[unowned self] isOn in
            self.configuration.font = isOn ? .openDyslexic : .defaultFont
        }

        // Tap to speak
        let speakOption = SwitchOption(title: "Tap to Speak",
                                       subtitle: "Words will be spoken aloud when a box is tapped.")
        speakOption.getter = { [unowned self] in
            return self.configuration.isTapToSpeakEnabled
        }
        speakOption.setter = { [unowned self] isOn in
            self.configuration.isTapToSpeakEnabled = isOn
        }

        let section1 = [fontOption, speakOption]


        // Credits
        let creditsOption = SelectableOption(title: "Credits") { [unowned self] in
            // Show credits controller
            let controller = CreditsViewController()
            self.show(controller, sender: nil)
        }
        let sections2 = [creditsOption]

        return [section1, sections2]
    }


    // MARK: - Delegate / Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.section][indexPath.row]
        let identifier = type(of: option).reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        option.configure(cell: cell)

        // This isn't ideal, but it's good enough for now
        cell.layoutIfNeeded()

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = options[indexPath.section][indexPath.row] as? SelectableOption else { return }
        option.onSelection()
    }
}
