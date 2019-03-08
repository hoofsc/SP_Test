//
//  OfficesCollectionViewController.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OfficeCollectionViewCell"

class OfficesCollectionViewController: UICollectionViewController {

    let kItemsPerRow: CGFloat = 2
    let kItemSpacing: CGFloat = 20.0
    let kEstimatedWidth: CGFloat = 140.0
    let kEstimatedHeight: CGFloat = 320.0
    
    var clinicianId: Int?
    var serviceCode: ServiceCode?
    var offices = [Office]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard clinicianId != nil, serviceCode != nil else {
            return
        }
        self.navigationItem.prompt = serviceCode!.description
        
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
        
        OfficesService.shared.getOffices(clinicianId: clinicianId!, serviceCodeId: Int(serviceCode!.id)!, completion: { offices in
            self.offices = offices!
        }) { error in
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
        return offices.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OfficeCollectionViewCell
    
        // Configure the cell
        cell.office = offices[indexPath.row]
    
        return cell
    }

}
