//
//  ChatroomMenuController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/7/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

extension ChatroomMenuController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterResults = chatroomGroups
            tableView.reloadData()
            return
        }
       
        filterResults = chatroomGroups.map({ (group) -> [String] in
            return group.filter {$0.lowercased().contains(searchText.lowercased())}
        })
        
        

        tableView.reloadData()
    }
}

class ChatroomMenuController: UITableViewController {
    
    
    
    let chatroomGroups = [
        ["general", "introductions"],
        ["Parents","Groomsmen", "Bridesmaids", "Ushers", "Officiant", "Readers", "Gest List"],
        ["Ramon Geronimo", "Jake Shams", "Jessie Pichardo", "Jon Kopp", "Storm Wold", "Adriana Gonzalez", "Dan Morse"]
    
    ]
    
    var filterResults = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterResults = chatroomGroups

//        tableView.backgroundColor = .purple
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "UNREADS" : section == 1 ? "CHANNELS" : "DIRECT MESSAGES"
    }
    
    fileprivate class ChatroomHeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let text = section == 0 ? "UNREADS" : section == 1 ? "CHANNELS" : "DIRECT MESSAGES"
        let label = ChatroomHeaderLabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(white: 0, alpha: 0.2)
        label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filterResults.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterResults[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatroomMenuCell(style: .default, reuseIdentifier: nil)
        let text = filterResults[indexPath.section][indexPath.row]
        cell.backgroundColor = .clear

        let attributedText = NSMutableAttributedString(string: "#  ", attributes: [.foregroundColor: UIColor(white: 0, alpha: 0.2), .font: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: text, attributes: [.foregroundColor: #colorLiteral(red: 0.8745098039, green: 0.6588235294, blue: 0.2705882353, alpha: 1), .font: UIFont.boldSystemFont(ofSize: 20)]))
        cell.textLabel?.attributedText = attributedText
        
        return cell
    }
}
