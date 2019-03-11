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
    
    let geolocateOperationQueue: OperationQueue = OperationQueue()
    
    var urlString: String {
        get {
            return APIController.shared.baseUrl + APIRoute.offices.rawValue
        }
    }
    
    func getOffices(clinicianId: Int, serviceCodeId: Int, completion: (([Office]?) -> Void)?, failure: @escaping ((Error) -> Void)) {
        
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }
        
        let params: Parameters = [
            "filter[clinicianId]": clinicianId,
            "filter[cptCodeId]": serviceCodeId
        ]
        
        let managedObjectContext = CoreDataController.shared.persistentContainer.viewContext
        let decoder = JSONDecoder()
        guard let kCodingUserInfoKeyManagedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext"),
            let kCodingUserInfoKeyServiceCodeId = CodingUserInfoKey(rawValue: "cptCodeId") else {
            fatalError()
        }
        decoder.userInfo[kCodingUserInfoKeyServiceCodeId] = serviceCodeId
        decoder.userInfo[kCodingUserInfoKeyManagedObjectContext] = managedObjectContext
        decoder.dateDecodingStrategy = .secondsSince1970
        let japxDecoder = JapxDecoder(jsonDecoder: decoder)
        
        let queue = DispatchQueue(label: EntityName.office.rawValue)
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: APIController.shared.headers)
            .validate()
            .responseCodableJSONAPI(queue: queue, includeList: nil, keyPath: "data", decoder: japxDecoder) { (response: DataResponse<[Office]>) in
                
//                debugPrint(response)
                
                if response.result.isSuccess {
                    if let offices = response.result.value {
                        CoreDataController.shared.save(context: managedObjectContext)
                        
                        var ops: [Operation] = []
                        _ = offices.map { office in
                            if office.geolocation == nil {
                                let op = GeolocateOperation(office: office) as Operation
                                ops.append(op)
                            }
                        }
                        self.geolocateOperationQueue.addOperations(ops, waitUntilFinished: true)
                        
                        DispatchQueue.main.async {
                            completion?(offices)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion?(nil)
                        }
                    }
                }
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
        }
    
    }
}
