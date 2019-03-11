//
//  LocationWrapper.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreLocation

@objc
public class GeoLocation: NSObject, Codable, NSCoding {
    
    var location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    // MARK: - Decodable
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CLLocation.CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.init(location: location)
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CLLocation.CodingKeys.self)
        try container.encode(location.coordinate.latitude, forKey: .latitude)
        try container.encode(location.coordinate.longitude, forKey: .longitude)
    }
    
    // MARK: - NSCoding
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(location.coordinate.latitude, forKey: "latitude")
        aCoder.encode(location.coordinate.longitude, forKey: "longitude")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let lat = aDecoder.decodeDouble(forKey: "latitude")
        let long = aDecoder.decodeDouble(forKey: "longitude")
        self.init(location: CLLocation(latitude: lat, longitude: long))
    }
    
}
