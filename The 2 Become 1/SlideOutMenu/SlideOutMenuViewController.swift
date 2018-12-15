//
//  SlideOutViewController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/5/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class SlideOutMenuViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(handleOpen))
            
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(handleHide))
        
        navigationController?.navigationBar.tintColor = .gold()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gold()]
    }
    
    
    @objc fileprivate func handleOpen(){
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }
    
    
    @objc fileprivate func handleHide(){
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.closeMenu()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.textLabel?.text = "Row: \(indexPath.row)"
        return cell
    }
    

}
