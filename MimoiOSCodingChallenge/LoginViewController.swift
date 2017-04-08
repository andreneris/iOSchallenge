//
//  LoginViewController.swift
//  MimoiOSCodingChallenge
//
//  Created by Andre Neris on 08/04/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import UIKit
import Foundation
import Auth0

@objc class LoginViewController: UIViewController {
    var onAuth: ((Result<Credentials>) -> ())!

    @IBOutlet var signUpView: UIView!
    @IBOutlet var signInView: UIView!
    @IBOutlet weak var newAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.translatesAutoresizingMaskIntoConstraints = false

        // Do any additional setup after loading the view.
        self.onAuth = { [weak self] in
            switch $0 {
            case .failure(let cause):
                let alert = UIAlertController(title: "Auth Failed!", message: "\(cause)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            case .success(let credentials):
                let token = credentials.accessToken ?? credentials.idToken
                let alert = UIAlertController(title: "Auth Success!", message: "Authorized and got a token \(token)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            print($0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        Auth0
            .authentication()
            .login(
                usernameOrEmail: "support@auth0.com",
                password: "a secret password",
                connection: "Username-Password-Authentication"
            )
            .start (onAuth)
    }

    @IBAction func newAccountAction(_ sender: UIButton) {
        showSignIn()
    }
    
    private func showSignIn () {
        

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
