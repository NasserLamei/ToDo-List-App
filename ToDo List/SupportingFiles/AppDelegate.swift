//
//  AppDelegate.swift
//  ToDo List
//
//  Created by nassermac on 6/22/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseCore
import FirebaseDatabase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
// MARK: - Properties
    var window: UIWindow?
    let mainStory = UIStoryboard(name: StoryBoards.main, bundle: nil)
    
// MARK: - AppLifeCycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database(url:URLs.fireBase)
        IQKeyboardManager.shared.enable = true
        handleRoot()
        return true
    }
// MARK: - Private Methods .
    private func handleRoot(){
        if let root = UserDefaults.standard.object(forKey: UserDefaultsKeys.token) as? Bool{
            if root{
                goToMainVC()
            }else{
                goTosignUpVC()
            }
        }
    }
    private func goToMainVC(){
        let mainVc: MainVC = mainStory.instantiateViewController(withIdentifier: Views.main) as! MainVC
        let navigator = UINavigationController(rootViewController: mainVc)
        self.window?.rootViewController = navigator
    }
    private func goTosignUpVC(){
        let signUp: SignUpVC = mainStory.instantiateViewController(withIdentifier: Views.signUp) as! SignUpVC
        let navigator = UINavigationController(rootViewController: signUp)
        self.window?.rootViewController = navigator
    }


}
