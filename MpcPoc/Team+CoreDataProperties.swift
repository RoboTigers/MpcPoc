//
//  Team+CoreDataProperties.swift
//  MpcPoc
//
//  Created by Sharon Kass on 2/21/16.
//  Copyright © 2016 RoboTigers. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Team {

    @NSManaged var teamNumber: String?
    @NSManaged var teamName: String?

}
