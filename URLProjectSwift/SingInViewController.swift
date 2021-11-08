//
//  SingInViewController.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 20.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import  Firebase

class SingInViewController: UIViewController {
    
    var activityIndicator : UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    lazy var continueButton: UIButton = {
       let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: self.view.center.x, y: self.view.frame.height - 100)
        button.backgroundColor = .white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.gray, for: .normal)
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSingIn), for: .touchUpInside)

        return button
    }()
    
    @objc private func handleSingIn() {
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if  let error = error {
                print(error.localizedDescription)
                self.setContinueButton(enabled: true)
                self.continueButton.setTitle("Contonue", for: .normal)
                self.activityIndicator.stopAnimating()
                return
            }
            print("Successfulty logged with email")
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
        
    }
    
    private func settingView() {
        view.addSubview(continueButton)
    }
    
   @objc private func textFieldChange() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let formFields = !(email.isEmpty) && !(password.isEmpty)
        setContinueButton(enabled: formFields)
    }
    
    private func setContinueButton(enabled: Bool) {
        if enabled {
            continueButton.alpha = 1
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc private func keyboarWillAppear(notification : Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        continueButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - keyboardFrame.height - 16 - continueButton.frame.height / 2)
        activityIndicator.center = continueButton.center
    }
    
    @IBOutlet weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.backgroundColor = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = continueButton.center
        view.addSubview(activityIndicator)
        setContinueButton(enabled: false)
        
        emailTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboarWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    @IBAction func singUpButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "SingUp", sender: sender)
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
