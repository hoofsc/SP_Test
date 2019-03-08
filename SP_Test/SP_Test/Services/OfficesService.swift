//
//  OfficesService.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import CoreLocation

class OfficesService: NSObject {
    
    static let shared = OfficesService()
    
    var urlString: String {
        get {
            return APIController.shared.baseUrl + APIRoute.offices.rawValue
        }
    }
    
    func getOffices(clinicianId: Int, serviceCodeId: Int, completion: @escaping (([Office]?) -> Void), failure: @escaping ((Error) -> Void)) {
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let params: Parameters = [
            "filter[clinicianId]": clinicianId,
            "filter[cptCodeId]": serviceCodeId
        ]
        
        let managedObjectContext = CoreDataController.shared.persistentContainer.viewContext
        let decoder = JSONDecoder()
        guard let kCodingUserInfoKeyManagedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext") else {
            fatalError()
        }
        decoder.userInfo[kCodingUserInfoKeyManagedObjectContext] = managedObjectContext
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
                            guard let street = offices[i].street,
                                let city = offices[i].city,
                                let state = offices[i].state,
                                let zip = offices[i].zip else {
                                completionCount += 1
                                return
                            }
                            let addressStr = "\(street) \(city) \(state) \(zip)"
                            let geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(addressStr, completionHandler: { (placemarks, error) in
                                defer {
                                    if completionCount == officeCount {
                                        try! managedObjectContext.save()
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
