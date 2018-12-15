//
//  BookmarksController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/7/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class BookmarksController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        cell.textLabel?.text = "Bookmark: \(indexPath.row)"
        return cell
    }
    

}
