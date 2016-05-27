//
//  Book+CoreDataProperties.swift
//  BookClub
//
//  Created by Michael Mecham on 5/26/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Book {

    @NSManaged var title: String
    @NSManaged var author: String
    @NSManaged var summary: String?
    @NSManaged var didRead: NSNumber

}
