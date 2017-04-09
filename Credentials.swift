//
//  Credential.swift
//  MimoiOSCodingChallenge
//
//  Created by Andre Neris on 08/04/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation


struct Credentials {
    let accessToken: String
    let idToken: String
    
    init (accessToken:String, idToken: String) {
        self.accessToken = accessToken
        self.idToken = idToken
    }
}
