//
//  Course+CoreDataProperties.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/10.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Course {

    @NSManaged var course_code: String?
    @NSManaged var course_name: String?
    @NSManaged var belongs_to_semester: Semester?
    @NSManaged var hasAssignment: NSSet?
    @NSManaged var hasClass: NSSet?
    @NSManaged var hasConsult: NSSet?
    
    func addClass(value: Class)
    {
        let course = self.mutableSetValueForKey("hasClass")
        course.addObject(value)
    }

}
