//
//  MainViewController.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 14.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import UserNotifications
import FBSDKLoginKit
import FirebaseAuth



enum Actions: String, CaseIterable {
    case downLoadImage = "DownLoad Image"
    case get = "Get"
    case post = "Post"
    case ourCourses = "Our Courses"
    case uploadInage = "Upload Image"
    case downloadFile = "Download File"
    case ourCoursesAlamofire = "OurCourses (AlamoFire)"
}

private let reuseIdentifier = "Cell"
let url  = "https://jsonplaceholder.typicode.com/posts"
private let uploadImage = "https://api.imgur.com/3/image"
private let dataProvider = DataProvide()

private var filePath : String?

class MainViewController: UICollectionViewController {
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            registryForNotification()
            dataProvider.fileLocation = { (locaion) in
                print("DownLoad FINISHED \(locaion.absoluteString)")
                filePath = locaion.absoluteString
                self.postNotification()
                self.alert.dismiss(animated: false, completion: nil)
            }
            
            chekedLoggedIn()
        }
    
//    let actions = ["DownLoad Image","Get","Post","Our Courses","Upload Image"]
    let actions = Actions.allCases
    
    private var alert: UIAlertController!
    private func showAlert() {
        alert = UIAlertController(title: "DownlLoading...", message: "0%", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive ) { (action) in
            dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        let height = NSLayoutConstraint(item: alert.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)
        
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.size.width / 2 - size.width / 2, y: self.alert.view.frame.size.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                            y: self.alert.view.frame.size.height - 44,
                                                            width: self.alert.view.frame.size.width,
                                                            height: 2))
            
            progressView.tintColor = .blue
            dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progressView.progress * 100)) + "%"
            }
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }



    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.row].rawValue
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        switch action {
        case .downLoadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(stringURL: url)
        case .post:
            NetworkManager.postRequset(stringURL: url)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadInage:
            NetworkManager.uploadImage(urlString: uploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
            print(action.rawValue)
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "OurCoursesWithAlamoFire", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CourcesViewController
        
        switch segue.identifier {
        case "OurCoursesWithAlamoFire":
            coursesVC?.fetchDataWithAlamofire()
        case "OurCourses":
            coursesVC?.fetchData()
        default:
            break
            
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension MainViewController {
    
   private func registryForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
   private func postNotification() {
    let content = UNMutableNotificationContent()
    content.title = "WodnLoad COMPLETED !!!"
    content.body = "Your file finiched to download, you can see file to link: \(filePath!)"
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)//триггер, по которому будет срабатывать уведомление, серез 3 секуды после окончания
    let request = UNNotificationRequest(identifier: "Transfer Complete", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension MainViewController {
    
    private func chekedLoggedIn() {
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true)
                return
            }
//            print("User is Logged!!!")
        }
    }
}
