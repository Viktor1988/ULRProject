//
//  Course.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 12.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import Foundation

struct Course: Decodable {
    
    let id : Int?
    let name : String?
    let link : String?
    let imageUrl : String?
    let number_of_lessons : Int?
    let number_of_tests : Int?
}
