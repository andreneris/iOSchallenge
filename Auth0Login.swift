//
//  Auth0Login.swift
//  MimoiOSCodingChallenge
//
//  Created by Andre Neris on 08/04/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation






@IBAction func loginAction(_ sender: UIButton) {
    Auth0
        .authentication()
        .login(
            usernameOrEmail: userNameText.text!,
            password: passwordText.text!,
            connection: "Username-Password-Authentication"
        )
        .start (onAuth)
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
    Auth0
        .authentication()
        .signUp(
            email: newUserNameText.text!,
            password: newPasswordText.text!,
            connection: "Username-Password-Authentication",
            userMetadata: ["first_name": "Foo", "last_name": "Bar"] // or any extra user data you need
        )
        .start (onAuth)
    
}
