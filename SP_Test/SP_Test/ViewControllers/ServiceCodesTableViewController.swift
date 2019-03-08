//
//  ServiceCodesTableViewController.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ServiceCodeTableViewCell"

class ServiceCodesTableViewController: UITableViewController {

    var clinicianId: Int = 2
    var serviceCodes = [ServiceCode]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServiceCodesService.shared.getServiceCodes(clinicianId: clinicianId, completion: { serviceCodes in
            self.serviceCodes = serviceCodes!
        }) { error in
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
        return serviceCodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ServiceCodeTableViewCell

        // Configure the cell...
        cell.serviceCode = serviceCodes[indexPath.row]
        
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
