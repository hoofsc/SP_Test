//
//  LocationWrapper.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreLocation

public struct GeoLocation: Codable {
    
    var location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CLLocation.CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.init(location: location)
    }
    
}
