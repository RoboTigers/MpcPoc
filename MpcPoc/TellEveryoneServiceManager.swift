//
//  TellEveryoneServiceManager.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/15/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit
import MultipeerConnectivity

// TODO: Adjust MCNearbyServiceBrowserDelegate implementation to manually invite peers so that scouts only sync data 
// with their own team and not with other teams using this app

// All devices will advertise the service and scan for the service at the same time. On iOS 8 this is supported - you can invite any
// peer you detect while browsing and the framework will handle simultaneous invites

// Declare a delegate protocol to notify the UI about service events
protocol TellEveryoneServiceManagerDelegate {
    
    func connectedDevicesChanged(manager : TellEveryoneServiceManager, connectedDevices: [String])
    func textChanged(manager : TellEveryoneServiceManager, textString: String)
    
}

class TellEveryoneServiceManager: NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let TellEveryoneServiceType = "tell-everyone"
    
    // An MCNearbyServiceBrowser to scan for the advertised service on other devices
    private let serviceBrowser : MCNearbyServiceBrowser
    private let myPeerId = MCPeerID(displayName: UIDevice.currentDevice().name)
    private let serviceAdvertiser : MCNearbyServiceAdvertiser

    // Create a lazy initialized session property to create a MCSession on demand
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session.delegate = self
        return session
    }()
    
    
    // A delegate property used for UI notification of service events
    var delegate : TellEveryoneServiceManagerDelegate?
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: TellEveryoneServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: TellEveryoneServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    // send data to connected peers
    func sendTextString(textString : String) {
        print("sendTextString: \(textString)")
        
        if session.connectedPeers.count > 0 {
            var error : NSError?
            do {
                try self.session.sendData(textString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
            } catch let error1 as NSError {
                error = error1
                print("\(error)")
            }
        }
        
    }

}

extension TellEveryoneServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("didNotStartAdvertisingPeer: \(error)");
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: NSData?,
        invitationHandler: (Bool,
        MCSession) -> Void) {
            print("didReceiveInvitationFromPeer \(peerID)")
            // accept received invitation
            // Note: This code accepts all incoming connections automatically.
            // To keep sessions private the user should be notified and asked to confirm incoming connections. 
            // This can be implemented using the MCAdvertiserAssistant classes.
            invitationHandler(true, self.session)
    }

}

extension TellEveryoneServiceManager : MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        // Invite any peer that is discovered
        // Note: This code invites any peer automatically. The MCBrowserViewController class could be used to scan for peers and invite them manually.
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
    }
    
}

extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
        case .NotConnected: return "NotConnected"
        case .Connecting: return "Connecting"
        case .Connected: return "Connected"
        //default: return "Unknown"
        }
    }
    
}

extension TellEveryoneServiceManager : MCSessionDelegate {
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.stringValue())")
        // delegate is notified when the connected devices change
        self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName}))

    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data) of length \(data.length) bytes")
        // delegate is notified when data is received
        let str = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        self.delegate?.textChanged(self, textString: str)
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        print("didFinishReceivingResourceWithName")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        print("didStartReceivingResourceWithName")
    }
    
}

    


