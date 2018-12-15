//
//  UserProfileController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/21/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    let cellId = "cellId"
    let homePostCellId = "homePostCellId"
    
    var userId: String?
    
    var isGridView = true
    
    func didChangeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        collectionView.reloadData()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        setupLogOutButton()
        fetchUser()
        
    }
    
    
    var isFinishedPaging = false
    var posts = [Post]()
    
    fileprivate func paginatePosts(){
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
//        var query = ref.queryOrderedByKey()
        var query = ref.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0 {
//            let value = posts.last?.id
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            
            
            allObjects.forEach({ (snapshot) in
                guard let user = self.user else {return}
                guard let dictionary = snapshot.value as? [String:Any] else {return}
               
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
            })
            
            self.posts.forEach({ (post) in
                print(post.id ?? "")
            })
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to paginate for posts:", err)
        }
    }
    
    fileprivate func fetchOrderedPosts(){
        guard let uid = user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshots) in
            
            guard let dictionary = snapshots.value as? [String: Any] else {return}
            guard let user = self.user else {return}
            
            let post = Post(user: user, dictionary: dictionary)
            
            // Insert photo in index 0
            self.posts.insert(post, at: 0)
            
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
        
    }
    
    
    
    fileprivate func setupLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 247, green: 208, blue: 120)
    }
    
    @objc func handleLogOut(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Faile to sign out:", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor.rgb(red: 247, green: 208, blue: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
            paginatePosts()
        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 40 + 8 + 8 //username userProfileImageView
            height += view.frame.width
            height += 50
            height  += 60
            
            return CGSize(width: view.frame.width, height: height)
           
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    // User object
    var user: User?
    
    
    // Cannot access it outside of this class
    fileprivate func fetchUser() {
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            // User object
            self.user = user
            
            // Set the Navigation bar title
            self.navigationItem.title = self.user?.username
            
            // Set the title color
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 240, green: 187, blue: 109)]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            
            self.collectionView.reloadData()
            
            self.paginatePosts()
        }
    
    }
    
}


