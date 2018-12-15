//
//  UserProfileHeader.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/21/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
            
        }
    }
    
    fileprivate func setupEditFollowButton(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if currentLoggedInUserId == userId {
            
        } else {
            
            // Check if following
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                    self.setupUnfollowStyle()
                    
                } else {
                    
                    self.setupFollowStyle()
                    
                    
                }
            }) { (err) in
                print("Failed to check if following:", err)
            }
            
            
        }
        
    }
    
    @objc func handleEditProfileOfFollow(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            // Unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
                    if let err = err {
                        print("Failed to unfollow user:", err)
                        return
                    }
                    print("Successfully unfollow user:", self.user?.username ?? "")
                self.setupFollowStyle()
            }
        } else {
            // Follow
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
                print("Successfully followed user:", self.user?.username ?? "")
                self.setupUnfollowStyle()
            }
        }
        
    }
    
    func setupUnfollowStyle(){
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor.rgb(red: 240, green: 187, blue: 109).cgColor
        self.editProfileFollowButton.backgroundColor = nil
    }
    
    func setupFollowStyle(){
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 240, green: 187, blue: 109)
    }
    
    let profileImageView: CustomeImageView = {
        let image = CustomeImageView()
        image.layer.borderColor = UIColor.rgb(red: 247, green: 208, blue: 120).cgColor
        image.layer.borderWidth = 3
        return image
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        button.tintColor = .gold()
        return button
    }()
    
    @objc func handleChangeToGridView(){
        gridButton.tintColor = .gold()
        listButton.tintColor = UIColor(white: 0, alpha: 0.4)
        delegate?.didChangeToGridView()
    }
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.4)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToListView(){
        listButton.tintColor = .gold()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.4)
        delegate?.didChangeToListView()
    }
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.4)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(white: 0, alpha: 0.6)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textColor = UIColor(white: 0, alpha: 0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textColor = UIColor(white: 0, alpha: 0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textColor = UIColor(white: 0, alpha: 0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // lazy var to be able to modify btn title
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 247, green: 208, blue: 120), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.rgb(red: 247, green: 208, blue: 120).cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOfFollow), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: gridButton.topAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 35, paddingBottom: 0, paddingRight: 20, width: 0, height: 34)
        
        
     
    }
    
    fileprivate func setupUserStatsView(){
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    }
    
    fileprivate func setupBottomToolbar(){
        let topDividerView  = UIView()
        topDividerView.backgroundColor = UIColor.rgb(red: 247, green: 208, blue: 120)
        
        let bottomDividerView  = UIView()
        bottomDividerView.backgroundColor = UIColor.rgb(red: 247, green: 208, blue: 120)
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        stackView.distribution = .fillEqually
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
