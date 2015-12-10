//
//  UserManager.swift
//  WalkinOrLogin
//
//  Created by Vu Tung on 12/10/15.
//  Copyright © 2015 Atlassian. All rights reserved.
//

import Foundation

typealias UserID = UInt16

var currentUser: User!

class User {
    let id: UserID
    var name: String
    init(id theID: UserID, name theName: String) {
        id = theID
        name = theName
    }
}