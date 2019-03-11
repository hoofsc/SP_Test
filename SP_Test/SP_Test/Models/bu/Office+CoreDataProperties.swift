//
//  Office+CoreDataProperties.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//
//

import Foundation
import CoreData


extension Office {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Office> {
        return NSFetchRequest<Office>(entityName: "Office")
    }

    @NSManaged public var oid: String?
    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var street: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zip: String?
    @NSManaged public var phone: String?
    @NSManaged public var isVideo: Bool
    @NSManaged public var services: NSSet?

}

// MARK: Generated accessors for services
extension Office {

    @objc(addServicesObject:)
    @NSManaged public func addToServices(_ value: ServiceCode)

    @objc(removeServicesObject:)
    @NSManaged public func removeFromServices(_ value: ServiceCode)

    @objc(addServices:)
    @NSManaged public func addToServices(_ values: NSSet)

    @objc(removeServices:)
    @NSManaged public func removeFromServices(_ values: NSSet)

}
