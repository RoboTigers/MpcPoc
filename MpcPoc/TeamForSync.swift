//
//  TeamForSync.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/21/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//

import Foundation

class TeamForSync : NSObject, NSCoding {
    var teamName : String = ""
    var teamNumber : String = ""
    
    @objc required init?(coder aDecoder: NSCoder) {
        print("Inializing TeamForSync")
        super.init()
    }
    
    @objc func encodeWithCoder(_ aCoder: NSCoder) {
        print("In encodeWithCoder");
    }
}