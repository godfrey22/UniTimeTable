//
//  Group+CoreDataProperties.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/8.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Group {
    @NSManaged var members: NSSet?
    func addTask(value: Semester)
    {
        let task = self.mutableSetValueForKey("members")
        task.addObject(value)
    }

}
