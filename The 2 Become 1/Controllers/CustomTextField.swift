//
//  CustomTextField.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/29/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding: CGFloat
    let height: CGFloat
    
    init(padding: CGFloat, height: CGFloat){
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
