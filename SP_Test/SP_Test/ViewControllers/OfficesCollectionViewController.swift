//
//  OfficesCollectionViewController.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "OfficeCollectionViewCell"

class OfficesCollectionViewController: UICollectionViewController, FetchedResultsControllerProtocol {
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var blockOperations: [BlockOperation]? = []
    
    let kItemsPerRow: CGFloat = 2
    let kItemSpacing: CGFloat = 20.0
    let kEstimatedWidth: CGFloat = 140.0
    let kEstimatedHeight: CGFloat = 320.0
    
    var clinicianId: Int?
    var serviceCode: ServiceCode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard clinicianId != nil, serviceCode != nil else {
            return
        }
        self.navigationItem.prompt = serviceCode!.desc
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let screen = UIScreen.main.bounds
        let availWidth = screen.width - (kItemSpacing * (kItemsPerRow+1))
        let itemWidth = availWidth / kItemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: kEstimatedHeight)
        layout.minimumLineSpacing = kItemSpacing
        layout.minimumInteritemSpacing = kItemSpacing
        layout.sectionInset = UIEdgeInsets(top: kItemSpacing, left: kItemSpacing, bottom: kItemSpacing, right: kItemSpacing)
        collectionView.collectionViewLayout = layout
        collectionView.collectionViewLayout.invalidateLayout()
        
        let fetchRequest = NSFetchRequest<ServiceCode>(entityName: EntityName.office.rawValue)
        let sortDescriptor = NSSortDescriptor(key: "oid", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "serviceCodes.oid CONTAINS %@", serviceCode?.oid ?? "")
        
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
        OfficesService.shared.getOffices(clinicianId: clinicianId!, serviceCodeId: Int(serviceCode!.oid!)!, completion: nil) { error in
            print("error: \(String(describing: error))")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        /*get number of rows count for each section*/
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OfficeCollectionViewCell
    
        // Configure the cell
        cell.office = fetchedResultsController?.object(at: indexPath) as? Office
    
        return cell
    }

}

extension OfficesCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations?.removeAll(keepingCapacity: false)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let op: BlockOperation
        switch (type) {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            op = BlockOperation() {
                self.collectionView.insertItems(at: [newIndexPath])
            }
        case .delete:
            guard let indexPath = indexPath else { return }
            op = BlockOperation() {
                self.collectionView.deleteItems(at: [indexPath])
            }
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            op = BlockOperation() {
                self.collectionView.moveItem(at: indexPath, to: newIndexPath)
            }
        case .update:
            guard let indexPath = indexPath else { return }
            op = BlockOperation() {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        blockOperations?.append(op)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard blockOperations != nil else { return }
        collectionView?.performBatchUpdates({
            self.blockOperations!.forEach({ op in
                    op.start()
            })
        }, completion: { (finished) in
            self.blockOperations?.removeAll(keepingCapacity: false)
        })
    }
    
}
