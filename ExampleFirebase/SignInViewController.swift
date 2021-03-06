//
//  SignInViewController.swift
//  ExampleFirebase
//
//  Created by talgat on 6/30/21.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var googleButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
    
    }
    
    enum AuthResult {
        case success
        case failure(Error)
    }
    
    func register(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        
        guard Validators.isFilled(firstname: firstNameTextField.text,
                                  lastName: lastNameTextField.text,
                                  email: emailTextField.text,
                                  password: passwordTextField.text) else {
                                    completion(.failure(AuthError.notFilled))
                                    return
        }
        guard let email = email, let password = password else {
            completion(.failure(AuthError.unknownError))
            return
        }
        
        guard Validators.isSimpleEmail(email) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let _ = result else {
                completion(.failure(error!))
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: [
                "firstname": self.firstNameTextField.text!,
                "lastname": self.lastNameTextField.text!,
                "uid": result!.user.uid
            ]) { (error) in
                if error != nil {
                    completion(.failure(AuthError.serverError))
                }
                completion(.success)
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        register(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            case .success:
                self.showAlert(with: "??????????????!", and: "")
                
            case .failure(let error):
                self.showAlert(with: "????????????", and: error.localizedDescription)
            }
        }
    }
    
    @IBAction func googleRegisterPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}
    

extension UIViewController {
    func showAlert(with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
