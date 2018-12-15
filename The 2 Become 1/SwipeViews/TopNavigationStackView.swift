//
//  TopNavigationStackView.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/27/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let centerImageView = UIImageView(image: #imageLiteral(resourceName: "font_logo"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        centerImageView.contentMode = .scaleAspectFill
        messageButton.contentMode = .scaleAspectFill
        centerImageView.contentMode = .scaleAspectFill
        clipsToBounds = true
        
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        [settingsButton, UIView(), centerImageView, UIView(), messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        
        distribution = .fillEqually
        
        isLayoutMarginsRelativeArrangement = true
//        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//class CustomButton: UIButton {
//
//    override var intrinsicContentSize: CGSize {
////        backgroundColor = .red
//        return CGSize(width: 10, height: 10)
//    }
//
//}
