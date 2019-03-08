//
//  ServiceCode.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit

struct ServiceCode: Codable {
    
    var id: String
    var type: String
    
    //attributes
    var description: String
    var duration: Int
    var rate: String
    var callToBook: String

}
