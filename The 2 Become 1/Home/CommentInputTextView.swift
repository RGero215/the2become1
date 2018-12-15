//
//  CommentInputTextView.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/27/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    fileprivate let placeholderLaberl: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func showPlaceHolderLabel() {
        placeholderLaberl.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLaberl)
        placeholderLaberl.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleTextChange(){
        placeholderLaberl.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
