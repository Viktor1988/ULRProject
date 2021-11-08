//
//  CurrentUser.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 20.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import Foundation
struct CurrentUser {
    var uid : String
    var name: String
    var email : String
    
    init?(uid: String, data: [String: Any]) {
        guard
            let name = data["name"] as? String,
            let email = data["email"] as? String
            else { return nil}
        self.uid = uid
        self.name = name
        self.email = email
    }
}
