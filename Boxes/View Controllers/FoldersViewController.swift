//
//  FoldersViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 3/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class FoldersViewController: BlurredBackgroundViewController {
    var folders: [Folder] = []
    let tableView = UITableView(frame: .zero, style: .plain)

    init() {
        super.init(nibName: nil, bundle: nil)

        title = "Folders"

        updateNavigationItems()

        DispatchQueue.global(qos: .background).async {
            self.loadFolders()
        }
    }

    private func updateNavigationItems() {
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_share"), style: .plain, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [shareButton]

        if !AccessControl.isReadOnly {
            let settingsItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_settings"), style: .plain, target: self, action: #selector(settingsTapped))
            navigationItem.leftBarButtonItem = settingsItem

            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            navigationItem.rightBarButtonItems?.insert(addButton, at: 0)
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }

    private func loadFolders() {
        do {
            let folders = try PersistenceHelper.userStorage.read()
            self.folders = folders

        } catch {
            // Load default Folders
            let defaults = try? PersistenceHelper.default.read()
            self.folders = defaults ?? []
        }

        // TableView only needs reload if the view has loaded already.
        guard isViewLoaded else { return }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(IconDetailCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.clipsToBounds = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    @objc func settingsTapped() {
        let config = Configuration()
        let controller = SettingsViewController(configuration: config)
        let nav = GlassNavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
        //TODO: Move credits into settings screen.
        //TODO: Make links tappable
//        let message = "Project is open sourced on GitHub www.github.com/bryanhathaway/sentences2\n\nIcons by www.icons8.com"
//        let controller = UIAlertController(title: "Credits", message: message, preferredStyle: .alert)
//        controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//        
//        present(controller, animated: true, completion: nil)
    }

    @objc private func addTapped(_ sender: Any) {
        presentFolderEditor(folder: Folder()) { [unowned self] folder in
            self.folders.append(folder)
            self.tableView.reloadData()
            try? PersistenceHelper.userStorage.save(folders: self.folders)
            self.splitViewController?.toggleMasterDisplayed()
        }
    }

    private func edit(folder: Folder) {
        presentFolderEditor(folder: folder, title: "Edit Folder") { [unowned self] folder in
            self.tableView.reloadData()
            try? PersistenceHelper.userStorage.save(folders: self.folders)
            self.splitViewController?.toggleMasterDisplayed()
        }
    }

    private func presentFolderEditor(folder: Folder, title: String? = nil, completion: @escaping ((Folder) -> ())) {
        let controller = FolderCreatorViewController(folder: folder)
        controller.onCancel = { [unowned self] in
            self.splitViewController?.toggleMasterDisplayed()
        }
        controller.completion = completion
        if let title = title {
            // Only override if specified.
            controller.title = title
        }

        let nav = GlassNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = CGSize(width: 500, height: 280)
        splitViewController?.present(nav, animated: true, completion: nil)
    }

    @objc func shareTapped() {
        let controller = SendReceiveViewController()
        controller.completion = { [unowned self] data in
            let newFolders = data.overwrite ? data.folders : self.mergedFolders(newFolders: data.folders)
            AccessControl.isReadOnly = data.isReadOnly

            try? PersistenceHelper.userStorage.save(folders: newFolders)
            self.folders = newFolders
            self.tableView.reloadData()
            self.splitViewController?.toggleMasterDisplayed()
            self.updateNavigationItems()
        }
        controller.cancel = { [unowned self] in
            self.splitViewController?.toggleMasterDisplayed()
        }
        controller.folders = folders
        
        let nav = GlassNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = CGSize(width: 500, height: 280)
        splitViewController?.present(nav, animated: true, completion: nil)
    }

    private func mergedFolders(newFolders: [Folder]) -> [Folder] {
        var mergedFolders = self.folders

        for folder in newFolders {
            guard let existing = mergedFolders.first(where: { $0.title == folder.title }) else {
                mergedFolders.append(folder)
                continue
            }

            for sentence in folder.sentences {
                if let existingSentence = existing.sentences.first(where: { $0.title == sentence.title }) {
                    existingSentence.update(with: sentence)
                } else {
                    existing.sentences.append(sentence)
                }
            }
        }

        return mergedFolders
    }

}

extension FoldersViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IconDetailCell

        let folder = folders[indexPath.row]
        cell.titleLabel.text = folder.title
        cell.detailLabel.text = folder.sentences.count > 0 ? folder.sentences.map { $0.title }.joined(separator: ", ") : "Empty"
        cell.sideColor = folder.color

        // This isn't ideal, but it's good enough for now
        cell.layoutIfNeeded()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let controller = SentencesViewController(folder: folders[indexPath.row])
        controller.delegate = self
        show(controller, sender: nil)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard !AccessControl.isReadOnly else { return [] }

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [unowned self] (action, indexPath) in
            self.edit(folder: self.folders[indexPath.row])
        }
        editAction.backgroundColor = #colorLiteral(red: 1, green: 0.6449120898, blue: 0.1902655968, alpha: 1)

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (action, path) in
            self.folders.remove(at: path.row)
            try? PersistenceHelper.userStorage.save(folders: self.folders)
            self.tableView.deleteRows(at: [path], with: .automatic)
        }

        return [deleteAction, editAction]
    }
}

extension FoldersViewController: SentencesDelegate {
    func sentencesController(_ controller: SentencesViewController, didChangeContentsOf folder: Folder) {
        // TODO: Error Handling
        try? PersistenceHelper.userStorage.save(folders: folders)
        tableView.reloadData()
    }
}
