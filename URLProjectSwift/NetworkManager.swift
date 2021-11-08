//
//  NetworkManager.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 14.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit


class NetworkManager{
    
    static func getRequest (stringURL: String) {
    let urlString = stringURL
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
    
    static func postRequset(stringURL: String) {
        let urlString = stringURL
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
    static func downloadImag(stringURL: String, completion: @escaping (_ image: UIImage)->()) {
        let stringURL = stringURL
        guard let url = URL(string:stringURL) else { return }
        
        let urlSession = URLSession.shared
        urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    static func fetchData(stringURL: String, completion: @escaping (_ courses:[Course])->()) {
        let jsonUrlString = stringURL
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            //            guard let response = response else { return }
            //            print("Response\(response)")
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                completion(courses)
                //                print("\(self.courses)")
                //                let webSiteDescription = try JSONDecoder().decode(WebSiteDescription.self, from: data)
                //                print("\(webSiteDescription.webSiteName ?? "Defautl NameSite") \(webSiteDescription.webSiteDescription ?? "DefaultDescription")")
            } catch let error {
                print("Error serialization JSON ",error)
            }
        }.resume()
    }
    
    static func uploadImage(urlString: String) {
        let image = UIImage(named: "Notification")!
        let httpHeaders = ["Authorization":"Client-ID 8379543110fcdab"]
        
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
        
        guard let url = URL(string: urlString) else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
}
