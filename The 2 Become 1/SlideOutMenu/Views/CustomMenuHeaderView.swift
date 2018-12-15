//
//  CustomMenuHeaderView.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/7/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class CustomMenuHeaderView: UIView {
    
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let statsLabel = UILabel()
    let profileImageView = ProfileImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupComponentProps()
        
        
        setupStackView()
        

    }
    
    // MARK:- Fileprivate
    fileprivate func setupComponentProps() {
        // Custom components for header
        nameLabel.text = "The 2 Become 1"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        nameLabel.textColor = .gold()
        usernameLabel.text = "@the2become1"
        usernameLabel.textColor = UIColor(white: 0, alpha: 0.5)
        statsLabel.text = "42 Following 7091 Followers"
        profileImageView.image = #imageLiteral(resourceName: "launch").withRenderingMode(.alwaysOriginal)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        setupStatsAttributedText()
    }
    
    fileprivate func setupStatsAttributedText(){
        statsLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        let attributedText = NSMutableAttributedString(string: "42 ", attributes: [.font: UIFont.systemFont(ofSize: 19, weight: .medium), .foregroundColor: UIColor.gold()])
        attributedText.append(NSMutableAttributedString(string: "Following ", attributes: [.foregroundColor: UIColor.gold()]))
        attributedText.append(NSAttributedString(string: "7091 ", attributes: [.font: UIFont.systemFont(ofSize: 19, weight: .medium), .foregroundColor: UIColor.gold()]))
        attributedText.append(NSAttributedString(string: "Followers", attributes: [.foregroundColor: UIColor.gold()]))
        statsLabel.attributedText = attributedText
    }
    
    fileprivate func setupStackView() {
        let rightSpacerView = UIView()
        let arrangedSubviews = [
            UIStackView(arrangedSubviews: [profileImageView, rightSpacerView]),
            nameLabel,
            usernameLabel,
            SpacerView(space: 16),
            statsLabel
        ]
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
