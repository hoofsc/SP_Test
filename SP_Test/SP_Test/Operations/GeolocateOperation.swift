//
//  GeolocateOperation.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class GeolocateOperation: AsyncOperation {

    weak var office: Office?
    
    init(office: Office) {
        self.office = office
    }
    
    override func execute() {
        guard let addressString = self.office?.formattedAddress,
            let oid = self.office?.oid else {
            print("geolocate operation requires Office.oid and Office.formattedAddress")
            self.isExecuting = false
            self.isFinished = true
            return
        }
       
        let moc = CoreDataController.shared.persistentContainer.newBackgroundContext()
        guard let threadSafeOffice1 = Office.fetch(oid: oid, in: moc) else {
            print("geocode error: Office not found in context \(moc)")
            self.isExecuting = false
            self.isFinished = true
            return
        }
        
        if threadSafeOffice1.geolocation == nil {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString, completionHandler: { (placemarks, error) in
                guard error == nil else {
                    print("geocode error: \(String(describing: error))")
                    self.isExecuting = false
                    self.isFinished = true
                    return
                }
                if let firstPlacemark = placemarks?.first,
                    let location = firstPlacemark.location {
                    guard let oid = self.office?.oid else {
                        self.isExecuting = false
                        self.isFinished = true
                        return
                    }
                    let moc = CoreDataController.shared.persistentContainer.newBackgroundContext()
                    guard let threadSafeOffice2 = Office.fetch(oid: oid, in: moc) else {
                        print("geocode error: Office not found in context \(moc)")
                        self.isExecuting = false
                        self.isFinished = true
                        return
                    }
                    threadSafeOffice2.geolocation = GeoLocation(location: location)
                    CoreDataController.shared.save(context: moc)
                    self.isExecuting = false
                    self.isFinished = true
                    return
                }
            })
        } else {
            print("Office.geolocation was fetched from cache.")
            self.isExecuting = false
            self.isFinished = true
            return
        }
    } 
    
}
