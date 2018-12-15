//
//  HomeController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/23/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 240, green: 187, blue: 109)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        
        setupNavigationItems()
        
        fetchAllPost()
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        fetchAllPost()
    }
    
    
    
    fileprivate func fetchAllPost(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching All post"
        hud.show(in:view)
        fetchPosts()
        fetchFollowingUserIds()
        hud.dismiss()
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostsWithUser(user: user)
                }
            })
            
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.fetchUserWithUID(uid: uid) {(user) in
            print("UID: ", uid)
            
            self.fetchPostsWithUser(user: user)
        }
        
        
    }

    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                })
            })
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "font_logo"))
        navigationItem.titleView?.contentMode = .scaleAspectFit
        navigationItem.titleView?.clipsToBounds = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3"), style: .plain, target: self, action: #selector(handleCamera))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2"), style: .plain, target: self, action: #selector(handleSend))
    }
    
    @objc func handleCamera() {
        print("shooting...")
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    @objc func handleSend(){
        print("sending...")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username userProfileImageView
        height += view.frame.width
        height += 50
        height  += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]

        cell.delegate = self
        
        return cell
    }
    
    func didTapComment(post: Post) {
        print(post.caption)
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didLike(for cell: HomePostCell){
        print("handle lkke inside of controller")
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let value = [uid: post.hasLiked == true ? 0 : 1]
        
        print(post.caption)
        Database.database().reference().child("likes").child(postId).updateChildValues(value) { (err, _) in
            if let err = err {
                print("Failed to like post:", err)
                return
            }
            print("Successfuly liked post.")
            post.hasLiked = !post.hasLiked
            
            self.posts[indexPath.item] = post
            
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}
