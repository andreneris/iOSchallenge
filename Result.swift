//
//  Result.swift
//  MimoiOSCodingChallenge
//
//  Created by Andre Neris on 08/04/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case success(result: Value)
    case failure(error: String)
}
