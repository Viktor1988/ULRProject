//
//  CourcesViewController.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 12.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import Alamofire

class CourcesViewController: UIViewController {
    private var courses = [Course]()
    private let stringURL = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    
    private var courseName : String?
    private var courseURL : String?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        NetworkManager.fetchData(stringURL: stringURL) { (couses) in
            self.courses = couses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkingRequest.sendRequest(url: stringURL)
    }
    
    private func configurateCell(cell: TableViewCell, for indexPath:IndexPath) {
        
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.number_of_lessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        if let numberOftests = course.number_of_tests {
            cell.numberOfTests.text = "Number of tests: \(numberOftests)"
        }
        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: imageData)
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController  = segue.destination as! WebViewViewController
        webViewController.sourseCurrent = courseName
        
        if let url = courseURL {
            webViewController.sourseURL = url
        }
    }
}
// MARK: Table View Data Source
extension CourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        configurateCell(cell: cell, for: indexPath)
        return cell
        
    }
}

// MARK: Table View Delegate
extension CourcesViewController  : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseCurrent = courses[indexPath.row]
        
        courseURL = courseCurrent.link
        courseName = courseCurrent.name
        
        performSegue(withIdentifier: "currentCourse", sender: self)
    }
}
