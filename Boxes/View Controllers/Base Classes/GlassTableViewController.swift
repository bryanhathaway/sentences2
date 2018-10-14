//
//  GlassTableViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 10/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class GlassTableViewController: BlurredBackgroundViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView: UITableView

    init(style: UITableView.Style) {
        tableView = UITableView(frame: .zero, style: style)

        super.init(nibName: nil, bundle: nil)

        backgroundImage = #imageLiteral(resourceName: "aurora2.jpg")
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
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.clipsToBounds = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        fatalError("Subclass must override")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("Subclass must override")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Subclass must override")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView

        let size = max(header.textLabel?.font.pointSize ?? 14.0, 14.0)
        header.textLabel?.font = .systemFont(ofSize: size)

        header.textLabel?.textColor = Theme.accent
    }
}
