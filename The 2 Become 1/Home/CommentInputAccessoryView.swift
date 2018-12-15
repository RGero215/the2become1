//
//  CommentInputAccessoryView.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/27/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextView.text = nil
        commentTextView.showPlaceHolderLabel()
    }
    
    fileprivate let commentTextView: CommentInputTextView = {
        let textView  = CommentInputTextView()
//        textView.placeholder = "Enter Comment"
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    fileprivate let submitButton: UIButton = {
        let sb = UIButton(type:.system)
        sb.setTitle("Submit", for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.setTitleColor(UIColor.rgb(red: 240, green: 187, blue: 109), for: .normal)
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(submitButton)
        addSubview(commentTextView)
        
        submitButton.anchor(top: topAnchor, left: nil, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        // 3
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupLineSeparatorView()
    }
    // 2
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupLineSeparatorView(){
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.8)
    }
    
    @objc func handleSubmit(){
        guard let commentText = commentTextView.text else {return}
        delegate?.didSubmit(for: commentText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
