//
//  Class+CoreDataProperties.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/16.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Class {

    @NSManaged var endDate: NSDate?
    @NSManaged var endTime: NSDate?
    @NSManaged var location: String?
    @NSManaged var startDate: NSDate?
    @NSManaged var startTime: NSDate?
    @NSManaged var week: NSNumber?
    @NSManaged var belongs_to_Course: Course?
    @NSManaged var hasTeacher: Teacher?
    @NSManaged var hasType: Type?

}
