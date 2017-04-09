//
//  UserInfo.swift
//  MimoiOSCodingChallenge
//
//  Created by Andre Neris on 09/04/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation

struct UserInfo{
    var email: String
    var picture: String
    
    init(email: String, picture: String) {
        self.email = email
        self.picture = picture
    }
}
