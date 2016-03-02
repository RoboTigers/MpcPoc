//
//  TellEveryoneViewController.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/15/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import UIKit
import CoreData

// Simple UI to test if the message is indeed send to all peers

class TellEveryoneViewController: UIViewController {
    
    // Tip: Can test that the service is advertised on the loxcal network either using the dns-sd terminal command:
    // dns-sd -B _services._dns-sd._udp
    let tellEveryoneService = TellEveryoneServiceManager()

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var msgInput: UITextField!
    @IBOutlet weak var connectionsLabel: UILabel!
    
    @IBAction func tellEveryoneAction(sender: AnyObject) {
        //msgLabel.text = msgInput.text
        //tellEveryoneService.sendTextString(msgInput.text!) // Only do this if sending (not receiving) data
        
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        // Grab values from text boxes
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: context)
        let myTeam = Team(entity: entity!, insertIntoManagedObjectContext: context)
        myTeam.teamName = "myName"
        myTeam.teamNumber = "myNumber"
        
        let teamDict : [String: AnyObject] = myTeam.toDictionary()
        print ("SHARON: teamDict = \(teamDict)")
        print ("SHARON: dict teamName: \(teamDict["teamName"])")
        
        var dictToSend = [String: AnyObject]()
        dictToSend["entityDiscriminator"] = "TEAM"
        dictToSend["entityObject"] = teamDict
        
        
        
        var myJson : NSData = NSData()
        do {
            try myJson = NSJSONSerialization.dataWithJSONObject(dictToSend, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("json error: \(error)")
        }
        print ("SHARON !!! myJson is \(myJson)")
        
        
        // just testing here - this needs to go to the place where data is received.. just testing now locally
        if let dictReceived: AnyObject = try! NSJSONSerialization.JSONObjectWithData(myJson, options: []) as? NSDictionary {
            print ("Dictionary received")
            print ("dictReceived = \(dictReceived)")
            let disriminator:String = (dictReceived["entityDiscriminator"] as? String)!
            let entityObject: NSDictionary = (dictReceived["entityObject"] as? NSDictionary)!
            print("discriminator received:  \(disriminator)")
            print("entity object received: \(entityObject)")
            if (disriminator == "TEAM") {
                print("Unpack json to get team data")
                let expectedTeamToReceive = Team(entity: entity!, insertIntoManagedObjectContext: context)
                let entityObject: NSDictionary = (dictReceived["entityObject"] as? NSDictionary)!
                expectedTeamToReceive.loadFromJson(entityObject)
                print ("expectedTeamToReceive = \(expectedTeamToReceive)")
            }
            print("done with test - did you get a team???")
        }
            // end testing
        
        
        
        tellEveryoneService.sendData(myJson)
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
    
    func dataChanged(manager: TellEveryoneServiceManager, data: NSData) {
        print("In TEVC, dataChanged")
        // Get data store context
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: context)
        let receivedTeam = Team(entity: entity!, insertIntoManagedObjectContext: context)
        
        
        // Get received team from json data
        //receivedTeam.loadFromJson(data)
        
        if let dictReceived: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
            print ("Dictionary received")
            print ("dictReceived = \(dictReceived)")
            
            
            let disriminator:String = (dictReceived["entityDiscriminator"] as? String)!
            let entityObject: NSDictionary = (dictReceived["entityObject"] as? NSDictionary)!
            print("discriminator received:  \(disriminator)")
            print("entity object received: \(entityObject)")
            if (disriminator == "TEAM") {
                print("Unpack json to get team data")
                receivedTeam.loadFromJson(entityObject)
            }
            
            
            print ("unpacked team = \(receivedTeam)")
        }
        
        
        
        print ("receivedTeam = \(receivedTeam)")
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.reflectReceivedMessage(receivedTeam.teamName!)
        }
    }
    
}
