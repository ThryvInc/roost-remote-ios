//
//  Auth.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/30/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import Foundation

func auth(username: String, password: String) -> Auth {
    return Auth(username: username, password: password)
}

struct Auth {
    var username: String
    var password: String
}
extension Auth: Codable {}
