//
//  VendorOrCouple.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/13/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class VendorOrCouple: UIViewController {
    let store: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Store Authentication", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .gold()
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleStore), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleStore(){
        let storeVC = RegistrationController()
        let navBarVC = UINavigationController(rootViewController: storeVC)
        present(navBarVC, animated: true, completion: nil)
    }
    
    let user: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("User Authentication", for: .normal)
        button.tintColor = .gold()
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gold().cgColor
        button.layer.borderWidth = 2
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleUser), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleUser(){
        let userVC = SignUpController()
        let navBarVC = UINavigationController(rootViewController: userVC)
        present(navBarVC, animated: true, completion: nil)
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            store,
            user,
        ])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }
    
    fileprivate func setupButtons(){
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchorForSwipe(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
    }
}
