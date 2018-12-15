//
//  ChatLogController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/9/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var store: Store? {
        didSet {
            navigationItem.title = store?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let storeMessagesRef = Database.database().reference().child("store-messages").child(uid)
        storeMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                let message = Message(dictionary: dictionary)
                if message.chatPartnerId() == self.store?.uid {
                    self.messages.append(message)
    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
    }
    
    
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputComponents()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = .white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text

        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message){
        if let profileImageUrl = self.store?.imageUrl1 {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        if message.fromUID == Auth.auth().currentUser?.uid {
            // Outgoing gold
            cell.bubbleView.backgroundColor = ChatMessageCell.darkGold
            //we set this up again because cell get reuse and can cause trouble
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewViewRightAnchor?.isActive = true
            cell.bubbleViewViewLeftAnchor?.isActive = false
        } else {
            // Incoming gray
            cell.bubbleView.backgroundColor = .lightGray
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewViewRightAnchor?.isActive = false
            cell.bubbleViewViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .heavy)], context: nil)
    }
    
    fileprivate func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.tintColor = .gold()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
        containerView.addSubview(inputTextField)
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        
        
        NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
                containerView.heightAnchor.constraint(equalToConstant: 50),
                
                sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                sendButton.widthAnchor.constraint(equalToConstant: 80),
                sendButton.heightAnchor.constraint(equalToConstant: 50),
                
                inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
                inputTextField.heightAnchor.constraint(equalToConstant: 50),

        ])
        
        separatorLineView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.8)
        
        
        
    }
    
    @objc fileprivate func handleSend(){
        guard let fromUID = Auth.auth().currentUser?.uid else {return}
        guard let toStoreUID = store?.uid else {return}
        guard let text = inputTextField.text else {return}
        let timestamp = Date().timeIntervalSince1970
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let value = [
            "toStoreUID": toStoreUID,
            "fromUID": fromUID,
            "text": text,
            "timestamp": timestamp
            ] as [String : Any]
        
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            
            guard let messageId = childRef.key else {return}
            
            let storeMesssageRef = Database.database().reference().child("store-messages").child(fromUID).child(messageId)
            storeMesssageRef.setValue(1)
            let recipientMessagesRef = Database.database().reference().child("store-messages").child(toStoreUID).child(messageId)
            recipientMessagesRef.setValue(1)
            
        }
        
        
//        let db = Firestore.firestore()
//        let childRef = db.collection("messages").document()
//
//
//        childRef.setData(value) { (error) in
//            if error != nil {
//                print(error as Any)
//            }
//            let messageId = childRef.documentID
//            let storeMessagesRef = db.collection("store-messages").document(fromUID)
//
//            let recipientUserMessagesRef = db.collection("store-messages").document(toStoreUID)
//
//            storeMessagesRef.setData([messageId: 1], merge:true)
//
//            recipientUserMessagesRef.setData([messageId: 1], merge:true)
//        }
//
//
//        self.inputTextField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
        
    }
    
}
