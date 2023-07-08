//
//  ViewController.swift
//  ToDo List
//
//  Created by nassermac on 6/22/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
// MARK: - Outlets.
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let picker = UIDatePicker()
// MARK: - Propirets .
    let mainStory = UIStoryboard(name: StoryBoards.main, bundle: nil)
// MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.datePickerMode = .countDownTimer
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

// MARK: - Actions.
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if isDataEnterd(){
            if isDataValid(){
            signUp()
            }
        }
    }
    
    
    @IBAction func goSignInBtnTapped(_ sender: UIButton) {
        goToSignIn()
 }
// MARK: - Methods.
    private func signUp(){
        let infoDictionary = ["username": userNameTextField.text ?? "","mail": emailTextField.text ?? "","password":
            passwordTextField.text ?? ""]
        FirebaseRequestes.signUp(parameters: infoDictionary) {[weak self](succuss, error) in
            if error == nil {
               self?.goToMain()
            } else{
                self?.showAlert(msg: error!)
                print(error!)
            }
        }
    }
   
    private func isDataEnterd()->Bool{
        guard userNameTextField.text != "" else {
            showAlert(msg: "Please, Enter Your Name")
            return false
        }
        guard emailTextField.text != "" else{
            showAlert(msg: "Please, Enter Valid Email. Example: test@example.com")
            return false
        }
        guard passwordTextField.text != "" else{
            showAlert(msg:"Please, Enter Valid Password: Example:Example@ ,at least 8 char and Contain Uppercase and Special char")
            return false
        }
        return true
    }
    private func isDataValid()->Bool{
        guard Validator.shared().isValidMail(mail: emailTextField.text!) else {
            showAlert(msg: "Please, Enter Valid Email. Example: test@example.com")
            return false
            }
        guard Validator.shared().isValidPassword(password: passwordTextField.text!)else{
            showAlert(msg:"Please, Enter Valid Password. Example:Aa12 ,at least 8 char ")
            return false
        }
        return true
    }
   
    private func goToSignIn(){
        let signinVc: SignInVC = mainStory.instantiateViewController(withIdentifier: Views.signIn) as! SignInVC
        self.navigationController?.pushViewController(signinVc, animated: true)

    }
    private func goToMain(){
        let mainVc: MainVC = mainStory.instantiateViewController(withIdentifier: Views.main) as! MainVC
        self.navigationController?.pushViewController(mainVc, animated: true)
        
    }
    
    
}

