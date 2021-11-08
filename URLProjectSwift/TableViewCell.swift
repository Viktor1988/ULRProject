//
//  TableViewCell.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 14.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var numberOfLessons: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!
}
