//
//  ChatroomMenuContainerControllerViewController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/8/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class ChatroomMenuContainerController: UIViewController {
    let chatroomMenuController = ChatroomMenuController()
    let searchContainer = SearchContainerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        let chatroomView = chatroomMenuController.view!
        view.addSubview(chatroomView)
        
        searchContainer.searchBar.delegate = chatroomMenuController
        
        view.addSubview(searchContainer)
        searchContainer.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
        searchContainer.anchorForSwipe(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        searchContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64).isActive = true
        chatroomView.anchorForSwipe(top: searchContainer.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }
}


class SearchContainerView: UIView {
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .minimal
        sb.placeholder = "Enter some filter"
        return sb
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "launch"))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .gray
        
        addSubview(searchBar)
        addSubview(profileImageView)
        
        profileImageView.anchorForSwipe(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 4, right: 0 ), size: .init(width: 50, height: 50))
        
        searchBar.anchorForSwipe(top: nil, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 4, bottom: 0, right: 4))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
