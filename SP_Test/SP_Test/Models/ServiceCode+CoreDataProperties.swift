//
//  ServiceCode+CoreDataProperties.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//
//

import Foundation
import CoreData


extension ServiceCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceCode> {
        return NSFetchRequest<ServiceCode>(entityName: "ServiceCode")
    }

    @NSManaged public var oid: String?
    @NSManaged public var type: String?
    @NSManaged public var desc: String?
    @NSManaged public var duration: Int16
    @NSManaged public var rate: Float
    @NSManaged public var callToBook: Bool
    @NSManaged public var offices: NSSet?

}

// MARK: Generated accessors for offices
extension ServiceCode {

    @objc(addOfficesObject:)
    @NSManaged public func addToOffices(_ value: Office)

    @objc(removeOfficesObject:)
    @NSManaged public func removeFromOffices(_ value: Office)

    @objc(addOffices:)
    @NSManaged public func addToOffices(_ values: NSSet)

    @objc(removeOffices:)
    @NSManaged public func removeFromOffices(_ values: NSSet)

}
