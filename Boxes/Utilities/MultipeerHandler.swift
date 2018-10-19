//
//  MultipeerHandler.swift
//  Boxes
//
//  Created by Bryan Hathaway on 5/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct TransportData: Codable {
    var folders: [Folder]
    var isReadOnly: Bool
    var overwrite: Bool
    var useOpenDyslexic: Bool
    var useTapToSpeak: Bool
}

class MultipeerHandler: NSObject, MCSessionDelegate {
    fileprivate static let serviceType = "TS-MP"
    fileprivate struct DiscoveryKey {
        static let detail = "DiscoveryKeyDetail"
    }

    fileprivate var peerID: MCPeerID
    fileprivate var mcSession: MCSession

    override init() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID,
                              securityIdentity: nil,
                              encryptionPreference: .optional)
        super.init()

        mcSession.delegate = self
    }

    // MARK: MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

class MultipeerSender: MultipeerHandler, MCNearbyServiceAdvertiserDelegate {

    private var serviceAdvertiser: MCNearbyServiceAdvertiser?

    let senderData: Data?

    init(transportData: TransportData) {
        senderData = try? JSONEncoder().encode(transportData)

        super.init()

        let word = transportData.folders.count == 1 ? "Folder" : "Folders"
        let discoveryInfo = [MultipeerHandler.DiscoveryKey.detail : "\(transportData.folders.count) \(word)"]

        let blah = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: MultipeerHandler.serviceType)
        blah.delegate = self
        blah.startAdvertisingPeer()
        serviceAdvertiser = blah
    }

    func send(data: Data, to peer: MCPeerID) {
        try? mcSession.send(data, toPeers: [peer], with: .reliable)
    }

    override func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            // TODO: Display error
            guard let data = senderData else { return }
            send(data: data, to: peerID)

        default: break
        }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
}

struct Peer {
    var peerID: MCPeerID
    var detailText: String?
}

class MultipeerReceiver: MultipeerHandler, MCNearbyServiceBrowserDelegate {

    typealias CompletionHandler = ((TransportData?) -> ())
    private let completion: CompletionHandler

    typealias PeersChangedHandler = (([Peer]) -> ())
    private let peersChanged: PeersChangedHandler

    private var browser: MCNearbyServiceBrowser?
    private var availablePeers: [Peer] = []

    init(peersChanged: @escaping PeersChangedHandler,
         completion: @escaping CompletionHandler) {

        self.completion = completion
        self.peersChanged = peersChanged

        super.init()
        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MultipeerHandler.serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        self.browser = browser
    }

    override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let transportData = try? JSONDecoder().decode(TransportData.self, from: data)
        DispatchQueue.main.async {
            self.completion(transportData)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let peer = Peer(peerID: peerID, detailText: info?[MultipeerHandler.DiscoveryKey.detail])
        availablePeers.append(peer)
        DispatchQueue.main.async {
            self.peersChanged(self.availablePeers)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        availablePeers = availablePeers.filter { $0.peerID != peerID }
        DispatchQueue.main.async {
            self.peersChanged(self.availablePeers)
        }
    }

    func select(peer: Peer) {
        browser?.invitePeer(peer.peerID, to: mcSession, withContext: nil, timeout: 7)
    }
}
