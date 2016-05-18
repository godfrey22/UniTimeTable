//
//  Assignment+CoreDataProperties.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/17.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Assignment {

    @NSManaged var assignment_due: NSDate?
    @NSManaged var assignment_status: String?
    @NSManaged var assignment_title: String?
    @NSManaged var belongs_to_Course: Course?
    @NSManaged var hasTask: NSSet?

}
