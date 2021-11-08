//
//  ImageViewController.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 12.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    private let stringURL = "https://altaitop.ru/wp-content/uploads/2020/02/bajk-zim-1.jpg"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicate: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicate.isHidden = true
        activityIndicate.startAnimating()
        fetchImage()
    }
    
    func fetchImage() {
        activityIndicate.isHidden = false
        activityIndicate.startAnimating()
        NetworkManager.downloadImag(stringURL: stringURL) { (image) in
            self.activityIndicate.stopAnimating()
            self.imageView.image = image
        }
    }
}
