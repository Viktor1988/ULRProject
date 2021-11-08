//
//  ViewController.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 11.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        
    }
    @IBAction func getRequestButton(_ sender: UIButton) {
        
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard  let response = response else { return }
            print("response%\(response )")
            
            guard let data = data else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
                
            }
            
            print("data:\(data)")
        }.resume()
    }
    @IBAction func postRequestButton(_ sender: UIButton) {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: urlString) else { return }
        
        let userData = ["Course":"Networking",
                        "Lesson":"Get And Post Request"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    @IBAction func ourCoursesButton(_ sender: UIButton) {
    }
}

