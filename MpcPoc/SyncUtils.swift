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
    
    func loadFromJson(jsonData : NSData) {
        //var dict : [String: AnyObject] = [String: AnyObject]()
        
        //do {
            //let error: NSError?
            if let dict: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary {
                print ("Dictionary received")
                print ("dict = \(dict)")
                self.teamName = dict["teamName"] as? String
                self.teamNumber = dict["teamNumber"] as? String
                print ("unpacked teamName = \(teamName)")
            }
//            else {
//                if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
//                    print ("JSON: \n\n \(jsonString)")
//                }
//                print ("Can't parse JSON \(error)")
//            }
        }
//        catch {
//            print ("Exception caught: \(error)")
//        }
        
    //}
    
}

//do {
//    try myJson = NSJSONSerialization.dataWithJSONObject(teamDict, options: NSJSONWritingOptions.PrettyPrinted)
//} catch {
//    print("json error: \(error)")
//}