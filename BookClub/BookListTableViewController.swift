//
//  BookListTableViewController.swift
//  BookClub
//
//  Created by Michael Mecham on 5/26/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//

import UIKit
import CoreData

class BookListTableViewController: UITableViewController {
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BookController.sharedController.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableViewDesign()
    }
    
    // MARK: - Action Buttons
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        presentAlertController()
    }
    
    //MARK: - Alert Controller
    
    func presentAlertController() {
        var bookTextField: UITextField?
        var authorTextField: UITextField?
        let alertController = UIAlertController(title: "Add New Book", message: "What book would you just love to read next?", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Book Title..."
            bookTextField = textField
        }
        alertController.addTextFieldWithConfigurationHandler { (aTextField) in
            aTextField.placeholder = "Author's Name..."
            authorTextField = aTextField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let createAction = UIAlertAction(title: "Add", style: .Default) { (_) in
            guard let title = bookTextField?.text, author = authorTextField?.text where title.characters.count > 0 && author.characters.count > 0 else { return }
            BookController.sharedController.addBook(title, author: author)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = BookController.sharedController.fetchedResultsController.sections else {return 0}
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = BookController.sharedController.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath) as? ButtonTableViewCell,
            book = BookController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Book else {
                return UITableViewCell()
        }
        cell.updateWithBook(book)
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = BookController.sharedController.fetchedResultsController.sections else {return nil}
        let value = Int(sections[section].name)
        if value == 0 {
            return "Potential Advertures"
        } else {
            return "Previous Adventures"
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 61 //self.view.frame.height / 9 - 7
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let book = BookController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Book else {
                return
            }
            BookController.sharedController.removeBook(book)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "AvenirNext-Bold", size: 20)
        title.textColor = UIColor.whiteColor()
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
        header.textLabel?.textAlignment = .Center
        header.backgroundView?.backgroundColor = UIColor(red: 46/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1)
    }
}

extension BookListTableViewController: BookTableViewCellDelegate {
    func buttonCellButtonTapped(cell: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell),
            book = BookController.sharedController.fetchedResultsController.objectAtIndexPath(indexPath) as? Book else { return }
        book.didRead = !book.didRead.boolValue
        cell.bookReadValueChanged(book.didRead.boolValue)
        BookController.sharedController.saveToPersistentStorage()
    }
}

extension BookListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case.Update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Move:
            guard let indexPath = indexPath, newIndexPath = newIndexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

extension BookListTableViewController {
    func tableViewDesign() {
        let backgroundImage = UIImage(named: "Library_BG")
        let imageView = UIImageView(image: backgroundImage)
        tableView.backgroundView = imageView
    }
}







