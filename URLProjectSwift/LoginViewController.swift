//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {
    
    var userProfile : UserProfile?
    
    lazy var customFBLoginButton: UIButton = {
        let loginButton = UIButton()
        
        loginButton.backgroundColor =  UIColor(hexValue: "#3B5999", alpha: 1)
        loginButton.setTitle("Login With FB", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.frame = CGRect(x: 32, y: 360 + 60, width: self.view.frame.size.width - 64, height: 50)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
        return loginButton
    }()
    
    lazy var customGoogleLoginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 + 30 + 80, width: self.view.frame.size.width - 64, height: 50)
        loginButton.backgroundColor = .white
        loginButton.setTitle("Login with google", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.gray, for: .normal)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        
        return loginButton
    }()
    
    lazy var googleButton: GIDSignInButton = {
       let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 + 30, width: self.view.frame.size.width - 64, height: 50)
        return loginButton
    }()
    
    lazy var fbLogoutButton: FBLoginButton = {
        let logoutButton = FBLoginButton()
        logoutButton.delegate = self
        logoutButton.frame = CGRect(x: 32, y: 360, width: self.view.frame.size.width - 64, height: 50)
        return logoutButton
    }()
    
    lazy var emailLogButton : UIButton = {
        var loginButton = UIButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 * 4 , width: self.view.frame.size.width - 64, height: 50)
        loginButton.setTitle("Login with email", for: .normal)
        loginButton.addTarget(self, action: #selector(openSingInVC), for: .touchUpInside)
        return loginButton
    }()
    
    func setupViews() {
        view.addSubview(customFBLoginButton)
        view.addSubview(googleButton)
        view.addSubview(fbLogoutButton)
        view.addSubview(customGoogleLoginButton)
        view.addSubview(emailLogButton)
    }
    
    @objc private func openSingInVC() {
        performSegue(withIdentifier: "SingIn", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        guard AccessToken.isCurrentAccessTokenActive else { return }
        //              fetchFaceBookFields()
        //              openMainViewController()
        print("Successfully logged in with facebook...")
        self.singIntoFireBase()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        print("Did LogOut of FaceBook")
        
    }
    
    private func openMainViewController() {
        dismiss(animated: true)
    }
    
    
    
    @objc private func handleCustomFBLogin() {
        LoginManager().logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            if let error = error {
                print("Error", error.localizedDescription)
                return
            }
            
            guard let result = result else { return }
            if result.isCancelled {
                return
            } else {
                self.singIntoFireBase()
            }
        }
    }
    
    private func singIntoFireBase() {
        
        let accessToken = AccessToken.current//берем текущий токен
        guard let accessTokenString = accessToken?.tokenString else { return }//если есть? импортируем  его в строку
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)//передает строку токена в fireBase для авторизации через FaceBook
        Auth.auth().signIn(with: credentials) { (user, error) in
            if let error = error {
                print("ComeThing went wrong our FaceBook user: ", error)
                return
            }
            print("Successfuly logged in with our FB user")
            self.fetchFaceBookFields()
        }
    }
    
    private func fetchFaceBookFields() {
        GraphRequest(graphPath: "me", parameters: ["fields":"id, name, email"]).start { (_, result, error) in
            if let error = error {
                print(error)
                return
            }
            if let userData = result as? [String : Any]  {
                self.userProfile = UserProfile(data: userData)
                print(self.userProfile?.name ?? "nil")
                self.saveInfoFirebase()
            }
        }
    }
    
    private func saveInfoFirebase() {
        guard let uId = Auth.auth().currentUser?.uid else { return }
        let userData = ["name":userProfile?.name, "email":userProfile?.email]
        let values = [uId:userData]
        Database.database().reference().child("users").updateChildValues(values) { (error, _) in
            if let error = error {
                print(error)
                return
            }
            print("Sucessfully saved user nto to firebase database")
            self.openMainViewController()
        }
    }
}

extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Faile to log into Google", error)
            return
        }
        print("Successfuly to log into Google")
        if let userName = user.profile.name, let email = user.profile.email {
            let userData = ["name":userName,"email":email]
            userProfile = UserProfile(data: userData)
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("SomeThing went wrong with our Google user ", error)
                return
            }
            print("Successfully logged into FireBAse with Google")
            self.saveInfoFirebase()
        }
    }
    
    @objc private func handleCustomGoogleLogin() {
        GIDSignIn .sharedInstance()?.signIn()
    }
    
    
}
