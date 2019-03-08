//
//  APIController.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import Alamofire

class APIController: NSObject {
    
    static let shared = APIController()
    
    let baseUrl = "https://johnny-appleseed.clientsecure.me/client-portal-api"
    
    // ex: https://johnny-appleseed.clientsecure.me/client-portal-api/offices?Accept=application/vnd.api+json&filter[clinicianId]=2&filter[cptCodeId]=3866
    
    let headers: HTTPHeaders = [
        "Accept": "application/vnd.api+json",
        "api-version": "2.0",
        "application-build-version": "2.0",
        "application-platform": "ios"
    ]
    
}
