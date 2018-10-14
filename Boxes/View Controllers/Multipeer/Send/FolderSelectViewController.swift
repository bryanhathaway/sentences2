//
//  FolderSelectViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 12/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class FolderSelectViewController: GlassTableViewController {
    private let reuseIdentifier = "Cell"

    var done: (() -> ())?
    var folders: [(folder: Folder, selected: Bool)]

    init(folders: [Folder]) {
        self.folders = folders.map { ($0, true) }
        super.init(style: .grouped)

        title = "Select Folders"

        tableView.register(GlassLabelCell.self, forCellReuseIdentifier: reuseIdentifier)

        let nextItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem = nextItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for index in 0..<folders.count {
            let path = IndexPath(row: index, section: 0)
            tableView.selectRow(at: path, animated: false, scrollPosition: .none)
        }
    }

    @objc func nextTapped() {
        let selected = folders.filter { $0.selected }.map { $0.folder }
        let controller = FolderOptionsViewController(folders: selected)
        controller.done = done
        show(controller, sender: nil)
    }

    // MARK: - Delegate / Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GlassLabelCell

        let folderInfo = folders[indexPath.row]

        cell.titleLabel.text = folderInfo.folder.title
        cell.subtitleText = folderInfo.folder.sentences.map { $0.title }.joined(separator: ", ")
        cell.accessoryType = folderInfo.selected ? .checkmark : .none
        cell.tintColor = Theme.accent

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        folders[indexPath.row].selected = true
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        folders[indexPath.row].selected = false
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }

}
