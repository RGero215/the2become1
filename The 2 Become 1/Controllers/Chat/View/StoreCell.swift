//
//  StoreCell.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/10/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

class StoreCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            detailTextLabel?.text = message?.text
            
            if let seconds = Double(message!.timestamp!.description) {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
        }
    }
    
    private func setupNameAndProfileImage(){
//        let chatPartnerId: String
//        if message?.fromUID == Auth.auth().currentUser?.uid {
//            chatPartnerId = message!.toStoreUID!
//        } else {
//            chatPartnerId = message!.fromUID!
//        }
//        
        if let id = message?.chatPartnerId() {
            
            let ref = Database.database().reference().child("stores").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any]  {
                    self.textLabel?.text = dictionary["storeName"] as? String
                    
                    if let storeImageUrl = dictionary["imageUrl1"]  as? String {
                        self.storeImageView.loadImageUsingCacheWithUrlString(storeImageUrl)
                    }
                    
                }
            }, withCancel: nil)

        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(storeImageView)
        addSubview(timeLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        storeImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        storeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        storeImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        storeImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

