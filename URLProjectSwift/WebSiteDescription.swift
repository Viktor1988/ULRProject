//
//  WebSiteDescription.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 13.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import Foundation

struct WebSiteDescription : Decodable {
    let webSiteDescription : String?
    let webSiteName : String?
    let courses : [Course]
}
