//
//  ViewController.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/12/21.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        isLoggingIn(true)
        UdacityClient.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        isLoggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            showAlert(message: "Please enter valid credentials.", title: "Login Error")
        }
    }
    
    func isLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.loginButton.isEnabled = false
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.loginButton.isEnabled = true
                
            }
        }
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    
    
}
// MARK:- Extension
extension UIViewController {
    func showAlert(message: String, title: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true)
        }
        
    }

}

