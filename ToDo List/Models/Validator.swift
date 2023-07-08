//
//  Validator.swift
//  ToDo List
//
//  Created by nassermac on 6/22/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import Foundation
class Validator{
    private static let sharedInstance = Validator()
    private var format = "SELF MATCHES %@"
    class func shared()->Validator{
        return Validator.sharedInstance
    }
    
    func isValidMail(mail:String)->Bool{
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let pred = NSPredicate(format: format, emailRegex)
        return pred.evaluate(with: mail)
        
    }
    func isValidPassword(password:String)->Bool{
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
      //  let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let pred = NSPredicate(format: format, passwordRegex)
        return pred.evaluate(with: password)
        
    }
}



