//
//  SentencesViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 1/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import UIKit

protocol SentencesDelegate: class {
    func sentencesController(_ controller: SentencesViewController, didChangeContentsOf folder: Folder)
}

class SentencesViewController: BlurredBackgroundViewController {
    weak var delegate: SentencesDelegate?

    private let folder: Folder
    private var sentences: [Sentence] {
        return folder.sentences
    }

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let configuration: Configuration

    init(folder: Folder, configuration: Configuration) {
        self.configuration = configuration
        self.folder = folder

        super.init(nibName: nil, bundle: nil)

        title = folder.title

        if !AccessControl.isReadOnly {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            navigationItem.rightBarButtonItem = addButton
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true

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

    @objc func addTapped(_ sender: Any) {
        let controller = SentenceEntryViewController(sentence: Sentence())

        controller.onCancel = { [weak self] in
            self?.splitViewController?.toggleMasterDisplayed()
        }

        controller.completion = { [weak self] sentence in
            guard let self = self else { return }

            self.folder.sentences.append(sentence)
            self.tableView.reloadData()

            let scrollToPath = IndexPath(item: self.folder.sentences.count - 1, section: 0)
            self.tableView.scrollToRow(at: scrollToPath, at: .bottom, animated: true)

            self.delegate?.sentencesController(self, didChangeContentsOf: self.folder)
            self.splitViewController?.toggleMasterDisplayed()
        }

        let nav = GlassNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = controller.modalPresentationStyle
        nav.preferredContentSize = controller.preferredContentSize
        splitViewController?.present(nav, animated: true, completion: nil)
    }

    func deleteSentence(at indexPath: IndexPath) {
        folder.sentences.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        delegate?.sentencesController(self, didChangeContentsOf: folder)
    }

    func editSentence(at index: Int) {
        let sentence = folder.sentences[index]
        let controller = SentenceEntryViewController(sentence: sentence)
        controller.title = "Edit Sentence"
        controller.onCancel = { [weak self] in
            self?.splitViewController?.toggleMasterDisplayed()
        }

        controller.completion = { [weak self] sentence in
            guard let self = self else { return }
            
            self.folder.sentences[index].update(with: sentence)
            self.tableView.reloadData()

            self.delegate?.sentencesController(self, didChangeContentsOf: self.folder)
            self.splitViewController?.toggleMasterDisplayed()
        }
        let nav = GlassNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = controller.modalPresentationStyle
        nav.preferredContentSize = controller.preferredContentSize
        splitViewController?.present(nav, animated: true, completion: nil)
    }
}

extension SentencesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentences.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IconDetailCell

        let sentence = sentences[indexPath.row]
        cell.titleLabel.text = sentence.title
        cell.titleLabel.font = configuration.font(ofSize: cell.titleLabel.font.pointSize)
        cell.detailLabel.text = sentence.compiledSentence
        cell.sideColor = sentence.color

        // This isn't ideal, but it's good enough for now
        cell.layoutIfNeeded()

        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard !AccessControl.isReadOnly else { return [] }

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (action, indexPath) in
            self?.editSentence(at: indexPath.row)
        }
        editAction.backgroundColor = #colorLiteral(red: 1, green: 0.6449120898, blue: 0.1902655968, alpha: 1)

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            self?.deleteSentence(at: indexPath)
        }

        return [deleteAction, editAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let splitViewController = splitViewController else { return }

        let sentence = sentences[indexPath.row]

        if splitViewController.isCollapsed {
            let controller = DetailViewController(configuration: configuration)
            show(controller, sender: nil)
            controller.setSentence(sentence)

        } else {
            guard let nav = splitViewController.viewControllers.last as? UINavigationController else { return }
            guard let controller = nav.topViewController as? DetailViewController else { return }
            controller.setSentence(sentence)
        }
    }
}

