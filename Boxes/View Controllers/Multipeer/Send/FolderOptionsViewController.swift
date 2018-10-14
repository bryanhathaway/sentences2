//
//  FolderOptionsViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 12/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit
private enum Option: CaseIterable {
    case overwrite
    case readonly

    var title: String {
        switch self {
        case .overwrite: return "Delete Existing"
        case .readonly: return "Read-Only Mode"
        }
    }

    var subtitle: String? {
        switch self {
        case .overwrite: return "These folders will become the only folders on the receiving device."
        case .readonly: return "The receiving device will be unable to create, edit, delete, or send any folders/sentences."
        }
    }
}

class FolderOptionsViewController: GlassTableViewController {
    private let reuseIdentifier = "Cell"

    var done: (() -> ())?
    let folders: [Folder]

    private var data: [Option: Bool] = [:]

    init(folders: [Folder]) {
        self.folders = folders

        super.init(style: .grouped)

        title = "Options"

        tableView.register(GlassSwitchCell.self, forCellReuseIdentifier: reuseIdentifier)

        let nextItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem = nextItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func nextTapped() {
        let controller = SendingViewController(folders: folders,
                                               readOnly: data[.readonly] ?? false,
                                               overwrite: data[.overwrite] ?? false)
        controller.done = done
        show(controller, sender: nil)
    }

    // MARK: - Delegate / Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Option.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GlassSwitchCell

        let option = Option.allCases[indexPath.row]

        cell.titleLabel.text = option.title
        cell.subtitleLabel.text = option.subtitle
        cell.switchView.tintColor = Theme.accent
        cell.switchView.onTintColor = Theme.accent
        cell.switchView.isOn = data[option] ?? false

        cell.valueChanged = { [weak self] selected in
            self?.data[option] = selected
        }

        // This isn't ideal, but it's good enough for now
        cell.layoutIfNeeded()

        return cell
    }
}
