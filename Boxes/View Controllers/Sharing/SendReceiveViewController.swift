//
//  SendReceiveViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 10/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit
private enum Mode: String {
    case send = "Send"
    case receive = "Receive"
}

class SendReceiveViewController: GlassTableViewController {
    private let reuseIdentifier = "Cell"
    private let modes: [Mode]

    var completion: ((TransportData) -> ())?
    var cancel: (() -> ())?
    var folders: [Folder]?

    init(configuration: Configuration) {
        modes = configuration.isReadOnlyMode ? [.receive] : [.send, .receive]
        super.init(style: .grouped)

        tableView.register(GlassLabelCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()

        title = "Folder Sharing"

        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func cancelTapped() {
        cancel?()
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Delegate / Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GlassLabelCell
        cell.titleLabel.text = modes[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch modes[indexPath.row] {
        case .send:
            guard let folders = folders, folders.count > 0 else { return }
            let controller = FolderSelectViewController(folders: folders)
            controller.done = cancel
            show(controller, sender: nil)

        case .receive:
            let controller = PeerPickerViewController()
            controller.completion = completion
            show(controller, sender: nil)

        }
    }
}
