//
//  UserProfileVC.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 19.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import GoogleUtilities
import GoogleDataTransport

class UserProfileVC: UIViewController {
    
    private var provider : String?
    private var currentUser : CurrentUser?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let loginButton = FBLoginButton()
        //        loginButton.delegate = self
        //        loginButton.frame = CGRect(x: 32,
        //                                   y: self.view.frame.size.height - 128,
        //                                   width: self.view.frame.size.width - 64,
        //                                   height: 28
        //        )
        //        view.addSubview(loginButton)
        
        //fetchingUserData()
        let logoutButton = UIButton()
        logoutButton.frame = CGRect(x: 32,
                                    y: self.view.frame.size.height - 128,
                                    width: self.view.frame.size.width - 64,
                                    height: 28
        )
        logoutButton.backgroundColor = UIColor(hexValue: "#3B5959", alpha: 1)
        logoutButton.setTitle("LogOut", for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 4
        logoutButton.addTarget(self, action: #selector(singOut), for: .touchUpInside)
        view.addSubview(logoutButton)
        //        setupViews()
        userNameLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       fetchingUserData()
    }
    
    //    lazy var fbLoginButton : UIButton = {
    //        let loginButton = FBLoginButton()
    //        loginButton.frame = CGRect(x: 32,
    //        y: self.view.frame.size.height - 128,
    //        width: self.view.frame.size.width - 64,
    //        height: 28)
    //        loginButton.delegate = self
    //        return loginButton
    //    }()
    //
    //    func setupViews() {
    //        view.addSubview(self.fbLoginButton)
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension UserProfileVC: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        print("Successfully logged in with facebook...")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
        openLoginViewController()
    }
    
    private func openMainViewController() {
        dismiss(animated: true)
    }
    
    private func openLoginViewController() {
        
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true)
                return
            }
        } catch  let error{
            print("Faild to SinInOut", error.localizedDescription)
        }
    }
    
    private func fetchingUserData() {
        if Auth.auth().currentUser != nil {
            if let userName = Auth.auth().currentUser?.displayName {
                activityIndicator.stopAnimating()
                userNameLabel.isHidden = false
                userNameLabel.text = getProviderData(with: userName)
            } else {
                guard  let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference()
                    .child("users")
                    .child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let userData = snapshot.value as? [String: Any] else { return }
                        self.currentUser = CurrentUser(uid: uid, data: userData)
                        self.activityIndicator.stopAnimating()
                        self.userNameLabel.isHidden = false
                        self.userNameLabel.text = self.getProviderData(with: self.currentUser?.name ?? "NONAME")
                    }) { (error) in
                        print(error)
                }
                
            }
        }
    }
    
    @objc private func singOut() {
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    LoginManager().logOut()
                    print("User did logout is FaceBook")
                    openLoginViewController()
                case "google.com":
                    GIDSignIn.sharedInstance()?.signOut()
                    print("User did logout is Google")
                    openLoginViewController()
                case "password":
                    try! Auth.auth().signOut()
                    print("User did logOut with password")
                    openLoginViewController()
                default:
                    print("User is signed in with \(userInfo.providerID)")
                }
            }
        }
        
    }
    
    private func getProviderData(with user:String)-> String {
        var grettings = ""
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    provider = "Facebook"
                case "google.com":
                    provider = "Google"
                case "password":
                    provider = "Email"
                default:
                    break
                }
            }
            grettings = "\(user) Loged in with  \(provider!)"
        }
        return grettings
    }
}
