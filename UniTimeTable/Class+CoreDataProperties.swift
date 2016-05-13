//
//  Class+CoreDataProperties.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/13.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Class {

    @NSManaged var time: NSDate?
    @NSManaged var location: String?
    @NSManaged var date: NSDate?
    @NSManaged var belongs_to_Course: Course?
    @NSManaged var hasTeacher: NSManagedObject?
    @NSManaged var hasType: NSManagedObject?

}
