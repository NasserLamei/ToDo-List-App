//
//  ViewController + Alert.swift
//  ToDo List
//
//  Created by nassermac on 6/22/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import UIKit
extension UIViewController{
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Sorry", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

