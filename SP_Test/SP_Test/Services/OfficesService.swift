//
//  OfficesService.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class OfficesService: NSObject {
    
    static let shared = OfficesService()
    
    func urlString() -> String {
        return "https://johnny-appleseed.clientsecure.me/client-portal-api/offices"
    }
    
    func getOffices(clinicianId: Int, serviceCodeId: Int, completion: @escaping (([Office]?) -> Void), failure: @escaping ((Error) -> Void)) {
        
        let urlStr = urlString()
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }
        
        let params: Parameters = [
            "filter[clinicianId]": clinicianId,
            "filter[cptCodeId]": serviceCodeId
        ]
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let japxDecoder = JapxDecoder(jsonDecoder: decoder)
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: APIController.shared.headers)
            .validate()
            .responseCodableJSONAPI(queue: nil, includeList: nil, keyPath: "data", decoder: japxDecoder) { (response: DataResponse<[Office]>) in
                
                debugPrint(response)
                
                if response.result.isSuccess {
                    var completionCount = 0
                    if var offices = response.result.value {
                        var officeCount = offices.count
                        for i in 0..<offices.count {
                            let addressStr = "\(offices[i].street) \(offices[i].city) \(offices[i].state) \(offices[i].zip)"
                            let geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(addressStr, completionHandler: { (placemarks, error) in
                                defer {
                                    if completionCount == officeCount {
                                        completion(offices)
                                    }
                                }
                                completionCount += 1
                                guard error == nil else {
                                    print("geocode error: \(String(describing: error))")
                                    return
                                }
                                if let firstPlacemark = placemarks?.first,
                                    let location = firstPlacemark.location {
                                    offices[i].geoLocation = GeoLocation(location: location)
                                }
                            })
                        }
                    }
                }
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }
        }
    
    }
}
