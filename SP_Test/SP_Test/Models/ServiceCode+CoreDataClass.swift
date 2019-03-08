//
//  ServiceCode+CoreDataClass.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ServiceCode)
public class ServiceCode: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case oid = "id"
        case type
        case desc = "description"
        case duration
        case rate
        case callToBook
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: EntityName.serviceCode.rawValue, in: managedObjectContext) else {
                fatalError("Failed to decode \(EntityName.serviceCode.rawValue)")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.oid = try! container.decodeIfPresent(String.self, forKey: .oid)!
        self.type = try! container.decodeIfPresent(String.self, forKey: .type)!
        self.desc = try! container.decodeIfPresent(String.self, forKey: .desc)!
        self.duration = Int16(try! container.decodeIfPresent(Int.self, forKey: .duration)!)
        self.rate = try! Float(container.decodeIfPresent(String.self, forKey: .rate)!)!
        self.callToBook = try! container.decodeIfPresent(String.self, forKey: .callToBook)! == "true" ? true : false
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oid, forKey: .oid)
        try container.encode(type, forKey: .type)
        try container.encode(desc, forKey: .desc)
        try container.encode(duration, forKey: .duration)
        try container.encode(rate, forKey: .rate)
        try container.encode(callToBook, forKey: .callToBook)
    }
    
}


