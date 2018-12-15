//
//  Message.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/9/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromUID: String?
    var text: String?
    var timestamp: NSNumber?
    var toStoreUID: String?
    var messageUID: String?
    
    init(dictionary: [String:Any]){
        
        self.fromUID = dictionary["fromUID"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.toStoreUID = dictionary["toStoreUID"] as? String
        self.messageUID = dictionary["messageUID"] as? String

    }
    
    func chatPartnerId() -> String? {
        return fromUID == Auth.auth().currentUser?.uid ? toStoreUID : fromUID
        
    }
}
