//
//  Task+CoreDataProperties.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/18.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var task_details: String?
    @NSManaged var task_due: NSDate?
    @NSManaged var task_percentage: NSNumber?
    @NSManaged var task_status: NSNumber?
    @NSManaged var task_title: String?
    @NSManaged var belongs_to_assignment: Assignment?

}
