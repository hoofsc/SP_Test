//
//  ServicesService.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ServiceCodesService: NSObject {
    
    static let shared = ServiceCodesService()
    
    var urlString: String {
        get {
            return APIController.shared.baseUrl + APIRoute.serviceCodes.rawValue
        }
    }
    
    func getServiceCodes(clinicianId: Int, completion: (([ServiceCode]?) -> Void)?, failure: @escaping ((Error) -> Void)) {
        
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }
        
        let params: Parameters = [
            "filter[clinicianId]": clinicianId
        ]
        
        let managedObjectContext = CoreDataController.shared.persistentContainer.newBackgroundContext()
        let decoder = JSONDecoder()
        guard let kCodingUserInfoKeyManagedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext"),
            let kCodingUserInfoKeyClinicianId = CodingUserInfoKey(rawValue: "clinicianId") else {
            fatalError()
        }
        decoder.userInfo[kCodingUserInfoKeyClinicianId] = clinicianId
        decoder.userInfo[kCodingUserInfoKeyManagedObjectContext] = managedObjectContext
        decoder.dateDecodingStrategy = .secondsSince1970
        let japxDecoder = JapxDecoder(jsonDecoder: decoder)
        
        let queue = DispatchQueue(label: EntityName.serviceCode.rawValue)
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: APIController.shared.headers)
            .validate()
            .responseCodableJSONAPI(queue: queue, includeList: nil, keyPath: "data", decoder: japxDecoder) { (response: DataResponse<[ServiceCode]>) in
                
//                debugPrint(response)
                
                 if response.result.isSuccess {
                    if let serviceCodes = response.result.value {
                        CoreDataController.shared.save(context: managedObjectContext)
                        DispatchQueue.main.async {
                            completion?(serviceCodes)
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

