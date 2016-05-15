//
//  Type+CoreDataProperties.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/15.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Type {

    @NSManaged var type_name: String?
    @NSManaged var belongs_to_Class: Class?

}
