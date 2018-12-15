//
//  MenuControllerTableViewController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/6/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

struct MenuItem {
    let icon: UIImage
    let title: String
}

extension MenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let slidingController = UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController
        slidingController?.didSelectMenuItem(indexPath: indexPath)
    }
}

class MenuController: UITableViewController {
    let menuItems = [
        MenuItem(icon: #imageLiteral(resourceName: "profile"), title: "Home"),
        MenuItem(icon: #imageLiteral(resourceName: "lists"), title: "Category"),
        MenuItem(icon: #imageLiteral(resourceName: "bookmarks"), title: "Bookmarks"),
        MenuItem(icon: #imageLiteral(resourceName: "moments"), title: "Moments")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customMenuHeader = CustomMenuHeaderView()
        return customMenuHeader
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuItemCell(style: .default, reuseIdentifier: "cellId")
        let menuItem = menuItems[indexPath.row]
        cell.titleLabel.text = menuItem.title
        cell.iconImageView.image = menuItem.icon
        cell.titleLabel.textColor = UIColor(white: 0, alpha: 0.5)

        return cell
    }

   
}
