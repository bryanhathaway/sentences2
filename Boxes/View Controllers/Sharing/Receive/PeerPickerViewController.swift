//
//  PeerPickerViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 10/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class PeerPickerViewController: GlassTableViewController {
    private let reuseIdentifier = "Cell"

    private var receiver: MultipeerReceiver?
    private var peers: [Peer] = []

    var completion: ((TransportData) -> ())?

    init() {
        super.init(style: .grouped)

        receiver = MultipeerReceiver(peersChanged: { [unowned self] peers in
            self.peers = peers
            self.tableView.reloadData()

        }, completion: { [unowned self] data in
            guard let data = data else { return }
            
            let controller = ReceivedViewController(transportData: data)
            controller.completion = self.completion
            self.show(controller, sender: nil)
        })

        title = "Select Sender"

        tableView.register(GlassLabelCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Delegate / Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GlassLabelCell

        let peer = peers[indexPath.row]

        cell.titleLabel.text = peer.peerID.displayName
        cell.accessoryType = .disclosureIndicator
        cell.subtitleText = peer.detailText

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        let indicator = UIActivityIndicatorView(style: .white)
        cell?.accessoryView = indicator
        indicator.startAnimating()

        receiver?.select(peer: peers[indexPath.row])
    }

}
