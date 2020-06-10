//
//  SigninViewController.swift
//  Snapagram
//
//  Created by Yuanrong Han on 3/16/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit
import Firebase
class SigninViewController: UIViewController {
    @IBOutlet weak var signInTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var snapagramLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true
        errorLabel.text = ""
        errorLabel.textColor = .red
        setupButtons()
        setupLogo()
    }
    
    private func setupButtons() {
        signinButton.backgroundColor = Constants.snapagramBlue
        signinButton.layer.cornerRadius = 5
        signinButton.setTitleColor(.white, for: .normal)
        signupButton.backgroundColor = Constants.snapagramBlue
        signupButton.layer.cornerRadius = 5
        signupButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupLogo() {
        snapagramLogo.image = UIImage(named: "snapagram_logo")
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let email = self.signInTextField.text, let password = self.passwordTextField.text else {
            print("Cannot be empty!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = String(error!.localizedDescription)
            } else {
                let mainViewController = self.storyboard?.instantiateViewController(identifier: Constants.mainViewController) as? UITabBarController
                self.view.window?.rootViewController = mainViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func didTapSignup(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUp", sender: sender)
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
