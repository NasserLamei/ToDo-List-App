//
//  PopUpVC.swift
//  ToDo List
//
//  Created by nassermac on 6/27/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import UIKit
import Firebase

class PopUpVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var dateAndTimeTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    var datePicker:UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePickerView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        dismissView()
        
    }
    private func dismissView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    private func setupUI() {
        contentImageView.layer.cornerRadius = 8
        view.backgroundColor = .init(white: 0.0, alpha: 0.5)
        dateAndTimeLabel.isHidden = true
    }
    
    private func setupDatePickerView() {
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 100, width: 320, height: 320))
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        datePicker.backgroundColor = UIColor.white
        if #available(iOS 13.4, *) {
        } else {
        }
        datePicker.autoresizingMask = .flexibleWidth
        dateAndTimeLabel.isHidden = false
        customView .addSubview(datePicker)

       let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(datePickerSelected))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolBar.sizeToFit()
        dateAndTimeTextField.inputAccessoryView = toolBar
        dateAndTimeTextField.inputView = customView
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if isDataEnterd(){
            let parameters = ["date": dateAndTimeTextField.text!, "content": contentTextField.text!]
            FirebaseRequestes.saveNotes(para: parameters)
              self.dismiss(animated: true, completion: nil)
        }
        print(contentTextField.text ?? "")
        print(dateAndTimeTextField.text ?? "")
      
    }
    
    @objc func datePickerSelected() {
        dateAndTimeTextField.text =  datePicker.date.description
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd h:mm a"
        dateAndTimeTextField.text = formatter.string(from: datePicker.date)
        dateAndTimeTextField.textColor = .purple
        dateAndTimeLabel.isHidden = false
        self.view.endEditing(true)
        
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    private func isDataEnterd()->Bool{
        guard dateAndTimeTextField.text != "" else{
            showAlert(msg: "Please, Choice Valid Date")
            return false
        }
        guard contentTextField.text != "" else{
            showAlert(msg: "Please, Enter Your Content ")
            return false
        }
      
        return true
    }
}
