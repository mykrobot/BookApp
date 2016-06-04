//
//  BookController.swift
//  BookClub
//
//  Created by Michael Mecham on 5/26/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//

import Foundation
import CoreData

class BookController {
    
    static let sharedController = BookController()
    
    var fetchedResultsController: NSFetchedResultsController
    
    // CRUD
    
    init() {
        let request = NSFetchRequest(entityName: "Book")
        let sortDescriptor = NSSortDescriptor(key: "didRead", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext , sectionNameKeyPath: "didRead", cacheName: nil)
        _ = try? fetchedResultsController.performFetch()
        
    }
    
    func addBook(title: String, author: String) {
        _ = Book(title: title, author: author)
        saveToPersistentStorage()
    }
    
//    func updateBook(book: Book, summary: String) {
//        book.summary = summary
//        saveToPersistentStorage()
//    }
    
    func removeBook(book: Book) {
        let moc = Stack.sharedStack.managedObjectContext
        moc.deleteObject(book)
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        let moc = Stack.sharedStack.managedObjectContext
        do {
            try moc.save()
        } catch {
            print("Failed to save to persistent storage \(#file) \(#function) \(#line)")
        }
    }
    
}







