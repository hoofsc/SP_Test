//
//  Office+CoreDataClass.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Office)
public class Office: NSManagedObject, Codable {
    
    //computed
    var geoLocation: GeoLocation?
    
    enum CodingKeys: String, CodingKey {
        case oid = "id"
        case type
        case name
        case street
        case city
        case state
        case zip
        case phone
        case isVideo
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: EntityName.office.rawValue, in: managedObjectContext) else {
                fatalError("Failed to decode \(EntityName.office.rawValue)")
        }
        self.init(entity: entity, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.oid = try! container.decodeIfPresent(String.self, forKey: .oid)!
        self.type = try! container.decodeIfPresent(String.self, forKey: .type)!
        self.name = try! container.decodeIfPresent(String.self, forKey: .name)!
        self.street = try! container.decodeIfPresent(String.self, forKey: .street)!
        self.city = try! container.decodeIfPresent(String.self, forKey: .city)!
        self.state = try! container.decodeIfPresent(String.self, forKey: .state)!
        self.zip = try! container.decodeIfPresent(String.self, forKey: .zip)!
        self.phone = try! container.decodeIfPresent(String.self, forKey: .phone)!
        self.isVideo = try! container.decodeIfPresent(Bool.self, forKey: .isVideo)!
        
        let fetchRequest = NSFetchRequest<ServiceCode>(entityName: EntityName.office.rawValue)
        fetchRequest.predicate = NSPredicate(format: "oid == %@", self.oid!)
        do {
            
            if let fetchedArr = try managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [Office] {
                print("off fetched count:")
                print(fetchedArr.count)
                if let fetched = fetchedArr.first {
                    fetched.type = type
                    fetched.name = name
                    fetched.street = street
                    fetched.city = city
                    fetched.state = state
                    fetched.zip = zip
                    fetched.phone = phone
                    fetched.isVideo = isVideo
                    print(fetched)
                } else {
                    managedObjectContext.insert(self)
                }
            }
        } catch {
            fatalError("Failed to fetch serviceCodes: \(error)")
        }
        
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oid, forKey: .oid)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(street, forKey: .street)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zip, forKey: .zip)
        try container.encode(phone, forKey: .phone)
        try container.encode(isVideo, forKey: .isVideo)
    }
}

