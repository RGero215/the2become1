//
//  User.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/23/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
