//
//  UserProfile.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 20.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import Foundation

struct UserProfile {
    var id: Int?
    var name: String?
    var email: String?
    
    init(data: [String : Any]) {
        let id = data["id"] as? Int
        let name = data["name"] as? String
        let email = data["email"] as? String
        
        self.id = id
        self.name = name
        self.email = email
    }
}
