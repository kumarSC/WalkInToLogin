//
//  UserManager.swift
//  WalkinOrLogin
//
//  Created by Vu Tung on 12/10/15.
//  Copyright © 2015 Atlassian. All rights reserved.
//

import Foundation

typealias UserID = String

let testUsers = [
    User(id: "sushant", name: "Shushant"),
    User(id: "tung", name: "Tung"),
    User(id: "hoang", name: "Hoang")
]

let SharedUserManager = UserManager()
class UserManager {
    var currentUser = testUsers[0]
    
    static func userNameOfID(id: UserID) -> String {
        let index = testUsers.indexOf { (user) -> Bool in
            user.id == id
        }
        if let index = index {
            return testUsers[index].name
        }
        return "Name"
    }
    func userWithID(id: UserID) -> User? {
        return User(id: id, name: UserManager.userNameOfID(id))
    }
}

class User {
    let id: UserID
    var name: String
    init(id theID: UserID, name theName: String) {
        id = theID
        name = theName
    }
}