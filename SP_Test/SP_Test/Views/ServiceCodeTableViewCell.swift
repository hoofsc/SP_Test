//
//  ServiceCodeTableViewCell.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit

class ServiceCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var serviceCode: ServiceCode? {
        didSet {
            descriptionLabel.text = serviceCode?.description
            durationLabel.text = "\(serviceCode?.duration ?? 0) minutes"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        descriptionLabel.text = ""
        durationLabel.text = ""
    }
}
