//
//  Teacher+CoreDataProperties.swift
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

extension Teacher {

    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var office: String?
    @NSManaged var phone: String?
    @NSManaged var belongs_to_Class: NSSet?

}
