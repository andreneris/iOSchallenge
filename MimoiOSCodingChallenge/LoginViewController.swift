//
//  LoginViewController.swift
//  MimoiOSCodingChallenge
//
//  Created by Andre Neris on 08/04/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import UIKit
import Foundation

@objc class LoginViewController: UIViewController {
    var onAuth: ((Result<Credentials>) -> ())!
    var onUserInfo: ((Result<UserInfo>) -> ())!

    
    @IBOutlet var signUpView: UIView!
    @IBOutlet var signInView: UIView!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var newUserNameText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var newAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        

        // Do any additional setup after loading the view.
        self.onUserInfo = { [weak self] in
            switch $0 {
            case .failure(let cause):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed!", message: "\(cause)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                
            case .success(let userinfo):
                DispatchQueue.main.async {
                    var vc = SettingsViewController()
                    vc.email = userinfo.email
                    vc.view.backgroundColor = UIColor.black
                    self?.present(vc, animated: true, completion: nil)
                }
            }
            
            print($0)
        }


        // Do any additional setup after loading the view.
        self.onAuth = { [weak self] in
            switch $0 {
            case .failure(let cause):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed!", message: "\(cause)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                
            case .success(let credentials):
                self?.hideSignUp()
                let token = credentials.idToken
                DispatchQueue.main.async {
                    let auth0Lib = Auth0Lib()
                    auth0Lib.userInfo(access_token: token, onCompletion: self?.onUserInfo)
                }
            }
            print($0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let auth0Lib = Auth0Lib()
        
        auth0Lib.signIn(username: userNameText.text!, password: passwordText.text!, onCompletion: onAuth)
    }

    @IBAction func newAccountAction(_ sender: UIButton) {
        if sender.isSelected {
            hideSignUp()
        }
        else {
            showSignUp()
            
        }
    }
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        let auth0Lib = Auth0Lib()
        auth0Lib.signUp(email: newUserNameText.text!, password: newPasswordText.text!, onCompletion: onAuth)
    
    }
    
    private func showSignUp () {
        newAccountButton.isSelected = true
        view.addSubview(signUpView)
        let bottomConstraint = signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leftConstraint = signUpView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = signUpView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = signUpView.heightAnchor.constraint(equalToConstant: 250)
        NSLayoutConstraint.activate([bottomConstraint, rightConstraint, leftConstraint, heightConstraint])
        
        
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            self.signUpView.transform = CGAffineTransform.identity
        }) { (finished) in
            
        }
    }
    
    private func hideSignUp() {
        newAccountButton.isSelected = false
        UIView.animate(withDuration: 0.5, animations: {
        }) { (finished) in
            if finished {
                self.signUpView.removeFromSuperview()
            }
        }
        
        view.layoutIfNeeded()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
