//
//  NewMessageController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/8/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellId = "cellId"
    var stores = [Store]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.tintColor = .gold()
        tableView.register(StoreCell.self, forCellReuseIdentifier: cellId)
        fetchStore()
    }
    
    fileprivate func fetchStore(){
        Database.database().reference().child("stores").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var store = Store(dictionary: dictionary)
                store.uid = snapshot.key
                self.stores.append(store)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
        
        
//        Firestore.firestore().collection("stores").getDocuments { (snapshot, err) in
//            if let err = err {
//                print("Error getting stores: ", err)
//                return
//            }
//            snapshot?.documents.forEach({ (documenteSnapshot) in
//                let storeDictionary = documenteSnapshot.data()
//                let store = Store(dictionary: storeDictionary)
//                self.stores.append(store)
//                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                
//            })
//        }
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let store = self.stores[indexPath.row]
            self.messagesController?.showChatControllerForStore(store: store)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StoreCell
        
        
        let store = self.stores[indexPath.row]
        cell.textLabel?.text = store.name
        cell.detailTextLabel?.text = store.category
        if let storeImageUrl = store.imageUrl1 {
            cell.storeImageView.loadImageUsingCacheWithUrlString(storeImageUrl)
        }
        
        
        return cell
    }

}

