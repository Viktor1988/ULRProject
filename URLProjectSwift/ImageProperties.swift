//
//  ImageProperties.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 15.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

struct ImageProperties {
    let key : String
    let data : Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil}
        self.data = data
    }
}
