//
//  LoginViewController.swift
//  ExampleFirebase
//
//  Created by talgat on 6/30/21.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginGoogle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        GIDSignIn.sharedInstance()?.delegate = self
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error != nil {
                
                print("some sign in error...")
            } else {
                print("Jump to the next screen")
            }
            print(result?.user.photoURL ?? "no photo")
        }
    }
    
    @IBAction func loginGooglePressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
}

  

