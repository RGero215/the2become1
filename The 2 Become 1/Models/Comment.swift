//
//  Comment.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/25/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import Foundation
struct Comment {
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String:Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
