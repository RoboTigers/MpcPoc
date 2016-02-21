//
//  TellEveryoneViewController.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/15/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit

// Simple UI to test if the message is indeed send to all peers

class TellEveryoneViewController: UIViewController {
    
    // Tip: Can test that the service is advertised on the loxcal network either using the dns-sd terminal command:
    // dns-sd -B _services._dns-sd._udp
    let tellEveryoneService = TellEveryoneServiceManager()

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var msgInput: UITextField!
    @IBOutlet weak var connectionsLabel: UILabel!
    
    @IBAction func tellEveryoneAction(sender: AnyObject) {
        msgLabel.text = msgInput.text
        tellEveryoneService.sendTextString(msgInput.text!) // Only do this if sending (not receiving) data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tellEveryoneService.delegate = self
        // Dismiss keyboard when user taps outside of keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
    }
    
    func dismissKeyboard() {
        msgInput.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reflectReceivedMessage (text: String) {
        msgLabel.text = text
    }

}

extension TellEveryoneViewController : TellEveryoneServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: TellEveryoneServiceManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func textChanged(manager: TellEveryoneServiceManager, textString: String) {
        print("In TEVC, textChanged and the text is \(textString)")
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.reflectReceivedMessage(textString)
        }
    }
    
}
