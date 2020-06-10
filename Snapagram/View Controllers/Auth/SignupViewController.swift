//
//  SignupViewController.swift
//  Snapagram
//
//  Created by Yuanrong Han on 3/16/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit
import Firebase
class SignupViewController: UIViewController {

    @IBOutlet weak var SignupEmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        PasswordTextField.isSecureTextEntry = true
        errorLabel.textColor = .red
        errorLabel.text = ""
        // Do any additional setup after loading the view.
        setupButtons()
    }
    
    private func setupButtons() {
        signupButton.backgroundColor = Constants.snapagramBlue
        signupButton.layer.cornerRadius = 5
        signupButton.setTitleColor(.white, for: .normal)
    }
    @IBAction func didTapSignup(_ sender: Any) {
        guard let email = self.SignupEmailTextField.text, let password = self.PasswordTextField.text else {
            self.errorLabel.text = "Both fields cannot be empty!"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = String(error!.localizedDescription)
            } else {
                self.errorLabel.text = "Successfuly created an account with email \(email)!"
            }
        }
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
