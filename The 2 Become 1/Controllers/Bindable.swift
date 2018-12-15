//
//  Bindable.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/3/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
