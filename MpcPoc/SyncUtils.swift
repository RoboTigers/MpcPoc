//
//  SyncUtils.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/24/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import Foundation

extension Team {
    
    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict["teamName"] = self.teamName
        dict["teamNumber"] = self.teamNumber
        return dict
    }
    
    func loadFromJson(teamDict : NSDictionary) {
        self.teamName = teamDict["teamName"] as? String
        self.teamNumber = teamDict["teamNumber"] as? String
        print ("unpacked teamName = \(teamName)")
    }
    
}

//do {
//    try myJson = NSJSONSerialization.dataWithJSONObject(teamDict, options: NSJSONWritingOptions.PrettyPrinted)
//} catch {
//    print("json error: \(error)")
//}