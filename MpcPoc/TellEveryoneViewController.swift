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
    
    let tellEveryoneService = TellEveryoneServiceManager()

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var msgInput: UITextField!
    @IBOutlet weak var connectionsLabel: UILabel!
    
    @IBAction func tellEveryoneAction(sender: AnyObject) {
        msgLabel.text = msgInput.text
        tellEveryoneService.sendTextString(msgInput.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tellEveryoneService.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension TellEveryoneViewController : TellEveryoneServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: TellEveryoneServiceManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func textChanged(manager: TellEveryoneServiceManager, textString: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.tellEveryoneAction(textString)
        }
    }
    
}
