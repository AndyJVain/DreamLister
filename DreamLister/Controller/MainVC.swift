//
//  MainVC.swift
//  DreamLister
//
//  Created by Andy Vainauskas on 1/10/18.
//  Copyright © 2018 Andy Vainauskas. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // Works with Core Data and TableView to makes it much easier to manage fetched results when
    // a fetch request is performed.
    // Efficiently collects results without needing to bring all results into memory at the same time
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        generateTestData()
        attemptFetch()
        
    }
    
    // Sets up the cells and dequeues when necessary
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: (indexPath as NSIndexPath))
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    // Sets the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    // Sets the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    // Ensure each row is a height of 150
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // When the user selects the TableView cell, the object with its data is sent in the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objects = controller.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // Get ready to pass information from first view to edit view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func attemptFetch() {
        // What kind of items we are fetching (items)
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // How to sort the data that is being fetched (by date)
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        // Change the sort mode based on the segment index
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else  if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        // The controller with the type we are fetching and the way of sorting the types (items) as parameters
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        // Perform the fetch
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    // Reloads the TableView when the segment is changed
    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    // Whenever the tableview is about to update, this will start to listen to changes and will handle them.
    // This is similar to tableview.reloadData()
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Called once the controller finished updating
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Listening for when we do make a change (insertion, deletion, modification)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: (indexPath as NSIndexPath))
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they release new MBPs."
        
        let item2 = Item(context: context)
        item2.title = "Tesla Model X"
        item2.price = 110000
        item2.details = "The obvious choice."
        
        let item3 = Item(context: context)
        item3.title = "Bose Headphones"
        item3.price = 300
        item3.details = "Noise-cancelling is the best!"
        
        ad.saveContext()
    }
    
}
