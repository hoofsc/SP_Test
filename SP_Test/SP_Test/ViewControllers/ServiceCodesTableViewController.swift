//
//  ServiceCodesTableViewController.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "ServiceCodeTableViewCell"

class ServiceCodesTableViewController: UITableViewController, FetchedResultsControllerProtocol {
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var blockOperations: [BlockOperation]?
    
    var clinicianId: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<ServiceCode>(entityName: EntityName.serviceCode.rawValue)
        let sortDescriptor = NSSortDescriptor(key: "oid", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = CoreDataController.shared.persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch let error {
            print("FETCH ERROR: \(error)")
        }

        fetchData()
    }
    
    func fetchData() {
        ServiceCodesService.shared.getServiceCodes(clinicianId: clinicianId, completion: nil) { error in
            print("error: \(String(describing: error))")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        /*get number of rows count for each section*/
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ServiceCodeTableViewCell

        // Configure the cell...
        let code = fetchedResultsController?.object(at: indexPath) as? ServiceCode
        cell.serviceCode = code
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let cell = sender as? ServiceCodeTableViewCell,
            let serviceCode = cell.serviceCode {
            if let vc = segue.destination as? OfficesCollectionViewController {
                vc.clinicianId = clinicianId
                vc.serviceCode = serviceCode
            }
        }
    }

}

extension ServiceCodesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    /*This delegate method will be called second. This method will give information about what operation exactly started taking place a insert, a update, a delete or a move. The enum NSFetchedResultsChangeType will provide the change types.
     public enum NSFetchedResultsChangeType : UInt {
         case insert
         case delete
         case move
         case update
     }
     
     */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .update:
                if let indexPath = indexPath,
                    let cell = tableView.cellForRow(at: indexPath) as? ServiceCodeTableViewCell,
                    let serviceCode = fetchedResultsController?.object(at: indexPath) as? ServiceCode {
                    cell.serviceCode = serviceCode
            }
            case .move:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
