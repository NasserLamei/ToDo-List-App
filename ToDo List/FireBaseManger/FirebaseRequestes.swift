//
//  FirebaseRequestes.swift
//  ToDo List
//
//  Created by nassermac on 6/23/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//import FirebaseAuth
import FirebaseDatabase


class FirebaseRequestes {
// MARK: - Properties
 static var ref = Database.database(url: URLs.fireBase).reference()
// MARK: - Methods .
   class func signUp(parameters:[String:String],completion:@escaping(_ success: Bool ,_ error: String?)->Void){
    Auth.auth().createUser(withEmail: parameters["mail"] ?? "", password: parameters["password"] ?? "") { user, fireBaseError in
            if fireBaseError == nil {
             self.saveUserInfo(para:parameters,newUser: user!)
                completion(true,nil)
            } else {
                completion(false,fireBaseError?.localizedDescription)
            }
       
    }
    }
    
  class func signIn(parameters:[String:String],completion:@escaping(_ success: Bool,_ error: String?)->Void){
        Auth.auth().signIn(withEmail:parameters["mail"] ?? "", password: parameters["password"] ?? "") {user,fireBaseError in
            if fireBaseError == nil{
                completion(true,nil)
            } else {
                completion(false,fireBaseError?.localizedDescription)
            }
            
        }
    }
    class func saveUserInfo(para:[String:String],newUser:User){
        let userNode = ref.child(Node.users).child(newUser.uid)
        userNode.setValue(para)
    } 

   class func saveNotes(para:[String:String]){
        let userID = Auth.auth().currentUser?.uid
        let noteRef = ref.child(Node.users).child(userID!).child(Node.notes).childByAutoId()
        noteRef.setValue(para)
    }
    
}
