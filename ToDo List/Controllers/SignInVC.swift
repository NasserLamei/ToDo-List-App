//
//  SignInVC.swift
//  ToDo List
//
//  Created by nassermac on 6/22/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import UIKit
import FirebaseDatabase


class SignInVC: UIViewController {

    // MARK: - Outlets.
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Properites.
    
    // MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
   
    
  // MARK: - Actions.
    @IBAction func logInBtnTapped(_ sender: UIButton) {
    signin()
    }
    
    @IBAction func goToSignUpBtnTapped(_ sender: UIButton) {
     self.navigationController?.popViewController(animated: true)
    }
    
    private func goToMain(){
        let mainStory = UIStoryboard(name: StoryBoards.main, bundle: nil)
        let mainVc: MainVC = mainStory.instantiateViewController(withIdentifier: Views.main) as! MainVC
        self.navigationController?.pushViewController(mainVc, animated: true)
    }
    private func signin(){
        let infoDictionary = ["mail": mailTextField.text ?? "","password":
            passwordTextField.text ?? ""]
       FirebaseRequestes.signIn(parameters: infoDictionary) {[weak self](succuss, error) in
            if error == nil {
                self?.goToMain()
            } else{
                self?.showAlert(msg: error!)
                print(error!)
            }
        }
    }
}
