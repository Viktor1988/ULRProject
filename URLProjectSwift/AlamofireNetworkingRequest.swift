//
//  AlamofireNetworkingRequest.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 16.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireNetworkingRequest {
    
    static func sendRequest(url: String) {
        guard let url = URL(string: url) else { return }
        AF.request(url).validate().responseJSON { response in
//            guard let status = response.response?.statusCode else { return }
//            print("Status: ", status)
//
//            if (200..<300).contains(status) {
//                let value = response.value
//                print("Value= ", value ?? "NIL")
//            } else {
//                let error = response.error
//                print(error ?? "error")
//            }
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
}
