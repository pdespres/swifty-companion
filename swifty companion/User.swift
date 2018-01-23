//
//  User.swift
//  swifty companion
//
//  Created by Paul DESPRES on 1/23/18.
//  Copyright © 2018 42. All rights reserved.
//

import Foundation

class User {
    
    var login: String
    var id: Int
    var fullName: String?
    var pool: String?
    var phone: String?
    var email: String?
    var location: String?
    var image: String?
    var isStaff: Bool?
    
    init(login: String, id: Int) {
        self.login = login
        self.id = id
    }
}
