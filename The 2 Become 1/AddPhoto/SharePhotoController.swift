//
//  SharePhotoController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/22/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 2400, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleShare(){
        guard let caption = textView.text, caption.count > 0 else {return}
        let storageRef = Storage.storage().reference()
        guard let image = selectedImage else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("post").child(filename)
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", error as Any)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let imageURL = url else {
                    // Uh-oh, an error occurred!
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to upload post image:", error ?? "")
                    return
                }
                 print("Successfully uploaded post image:", imageURL.absoluteString)
                self.saveToDatabaseWithImageUrl(imageUrl: imageURL.absoluteString)
            }
        }
        
    }
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImgage = selectedImage else  {return}
        guard let caption = textView.text else {return}
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let value = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImgage.size.width, "imageHeight": postImgage.size.height, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        
        ref.updateChildValues(value) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            print("Successfully save post to DB")
            self.dismiss(animated: true, completion: nil)
            
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
