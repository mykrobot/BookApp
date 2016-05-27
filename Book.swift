//
//  Book.swift
//  BookClub
//
//  Created by Michael Mecham on 5/26/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//

import Foundation
import CoreData


class Book: NSManagedObject {
    
    convenience init?(title: String, author: String, didRead: Bool = false, summary: String? = nil, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName("Book", inManagedObjectContext: context) else {return nil}
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.title = title
        self.author = author
        self.didRead = didRead
        self.summary = summary
    }
}
