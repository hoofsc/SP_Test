//
//  ServicesService.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import Alamofire

class ServiceCodesService: NSObject {
    
    static let shared = ServiceCodesService()
    
    func urlString() -> String {
        return "https://johnny-appleseed.clientsecure.me/client-portal-api/cpt-codes"
    }
    
    func getServiceCodes(clinicianId: Int, completion: @escaping (([ServiceCode]?) -> Void), failure: @escaping ((Error) -> Void)) {
        
        let urlStr = urlString()
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }
        
        let params: Parameters = [
            "filter[clinicianId]": clinicianId
        ]
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let japxDecoder = JapxDecoder(jsonDecoder: decoder)
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: APIController.shared.headers)
            .validate()
            .responseCodableJSONAPI(queue: nil, includeList: nil, keyPath: "data", decoder: japxDecoder) { (response: DataResponse<[ServiceCode]>) in
                
                debugPrint(response)
                
                 if response.result.isSuccess {
                    if let serviceCodes = response.result.value {
                        completion(serviceCodes)
                    }
                }
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }
        }
        
    }
}

