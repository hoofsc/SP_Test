//
//  CodingUserInfoKey+NSManagedObjectContext.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
    static let clinicianId = CodingUserInfoKey(rawValue: "clinicianId")
    static let cptCodeId = CodingUserInfoKey(rawValue: "cptCodeId")
}
