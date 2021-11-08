//
//  SingOutViewController.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 20.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import Firebase

class SingOutViewController: UIViewController {
    
    var activityIndicator : UIActivityIndicatorView!

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
        button.addTarget(self, action: #selector(handleSingUp), for: .touchUpInside)

        return button
    }()
    
    @objc private func handleSingUp() {
          setContinueButton(enabled: false)
          continueButton.setTitle("", for: .normal)
          activityIndicator.startAnimating()
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let userName = userNameTextField.text
            else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.continueButton.isEnabled = true
                self.continueButton.setTitle("Continue", for: .normal)
                self.activityIndicator.stopAnimating()
                return
            }
            print("Successfully with email")
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = userName
                changeRequest.commitChanges { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.setContinueButton(enabled: false)
                        self.continueButton.setTitle("", for: .normal)
                        self.activityIndicator.startAnimating()
                    }
                    print("User did change nikName")
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func settingView() {
        view.addSubview(continueButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            settingView()
        
        userNameTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.backgroundColor = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = continueButton.center
        view.addSubview(activityIndicator)
        setContinueButton(enabled: false)
    }
    
    @objc private func textFieldChange() {
        guard
            let userName = userNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else { return }
        let formFields = !(email.isEmpty) && !(password.isEmpty) && !(userName.isEmpty) && password == confirmPassword
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboarWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
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
