//
//  ActivityIndicator.swift
//  ToDo List
//
//  Created by nassermac on 7/4/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
import UIKit

class activtyIndicator{
    
    static func showActivtyIndicator(view:UIView)->UIActivityIndicatorView{
        let activty1 = UIActivityIndicatorView(style: .whiteLarge)
        DispatchQueue.main.async {
            activty1.center = view.center
            activty1.color = UIColor.red
            activty1.startAnimating()
            view.addSubview(activty1)
            
        }
        return activty1
    }
    
    static func stopActivtyIndicator(activty:UIActivityIndicatorView){
        DispatchQueue.main.async {
            activty.stopAnimating()
            activty.removeFromSuperview()
        }
    }
    
    
    
    
    
}
