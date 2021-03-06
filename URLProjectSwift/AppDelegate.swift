//
//  AppDelegate.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 11.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        
        
//        let appId = Settings.appID
//        if url.scheme != nil && url.scheme!.hasPrefix("fb\(String(describing: appId))") && url.host ==  "authorize" {
//            return ApplicationDelegate.shared.application(app, open: url, options: options)
//        }
        return GIDSignIn.sharedInstance().handle(url)
    }

    
    
    var bgSessionCompletionHandler: (()->())?
    //необходим захватить параметр наей сессии из completionHandler и сохранить у себя
    //в completionHandler передается идентификатор сессии? вызывающего запуск приложения
    //при запуске приложения идет и связывается с ней(нашей сохраненной сессией)
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        bgSessionCompletionHandler = completionHandler // сохраняем, чтобы при перезапуске приложения сравнить сессии, новую и сохраненную
    }
 
    
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

