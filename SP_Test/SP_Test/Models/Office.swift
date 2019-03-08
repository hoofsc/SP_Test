//
//  Office.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreLocation

struct Office: Codable {
    
    var id: String
    var type: String
    
    //attributes
    var name: String
    var street: String
    var city: String
    var state: String
    var zip: String
    var phone: String
    var isVideo: Bool
    
    //computed
    var geoLocation: GeoLocation?
    
}
