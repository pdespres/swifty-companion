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
    var campus: String?
    var cursus: String?
    var cursusId: Int?
    var level: Float?
    var projects: [Project] = []
    var skills: [(String, Float)] = []
    
    init(login: String, id: Int) {
        self.login = login
        self.id = id
    }
}

class Project {
    var id: Int
    var name: String
    var mark: Int?
    var validated: Bool?
    var status: String?
    var subproj: [Project]
    
    init(id: Int, name: String, mark: Int, validated: Bool, status: String, subproj: [Project]) {
        self.id = id
        self.name = name
        self.mark = mark
        self.validated = validated
        self.status = status
        self.subproj = subproj
    }
}
