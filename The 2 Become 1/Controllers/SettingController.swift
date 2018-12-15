//
//  SettingController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/4/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSetting()
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: SettingsControllerDelegate?
    
    // instance properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton){
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button

        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/brands_images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to upload image to storage:", err)
                return
            }
            print("Finished uploading image")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Failed to retrieve download URL:", err)
                    return
                }
                print("Finished getting download URL:", url?.absoluteString ?? "")
                
                if imageButton == self.image1Button {
                    self.store?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.store?.imageUrl2 = url?.absoluteString
                } else {
                    self.store?.imageUrl3 = url?.absoluteString
                }
            })
        }
    }

    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.tintColor = .gold()
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    var store: Store?
    
    fileprivate func fetchCurrentUser() {
        // fetch some Firestore
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("stores").child(uid).observe(.value, with: { (snapshot) in
            // fetched our user
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            self.store = Store(dictionary: dictionary)
            print("Store", self.store as Any)
            
            self.loadStorePhotos()
            
            self.tableView.reloadData()
        }) { (err) in
        
            print(err)
            return
        
        }
        
//        Firestore.firestore().collection("stores").document(uid).getDocument { (snapshot, err) in
//            if let err = err {
//                print(err)
//                return
//            }
//            // fetched our user
//            guard let dictionary = snapshot?.data() else {return}
//            self.store = Store(dictionary: dictionary)
//            print("Store", self.store)
//            
//            self.loadStorePhotos()
//            
//            self.tableView.reloadData()
//            
//        }
    }
    
    fileprivate func loadStorePhotos(){
        if let imageUrl = store?.imageUrl1, let url = URL(string: imageUrl){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)

            }
        }
        
        if let imageUrl = store?.imageUrl2, let url = URL(string: imageUrl){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                
            }
        }
        
        if let imageUrl = store?.imageUrl3, let url = URL(string: imageUrl){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                
            }
        }
        
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchorForSwipe(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchorForSwipe(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding
            , bottom: padding, right: padding))
        return header
    }()
    
    class HeaderLabel: UILabel{
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Category"
        case 3:
            headerLabel.text = "Price"
        case 4:
            headerLabel.text = "Description"
        default:
            headerLabel.text = "Seeking Price Range"
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.textColor = .gold()
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    @objc fileprivate func handleMinPriceChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let priceRangeCell = tableView.cellForRow(at: indexPath) as! PriceRangeCell
        priceRangeCell.minLabel.text = "Min \(Int(slider.value))"
        
        self.store?.minSeekingPrice = Int(slider.value)
        
    }
    
    @objc fileprivate func handleMaxPriceChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let priceRangeCell = tableView.cellForRow(at: indexPath) as! PriceRangeCell
        priceRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        self.store?.maxSeekingPrice = Int(slider.value)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let priceRangeCell = PriceRangeCell(style: .default, reuseIdentifier: nil)
            priceRangeCell.minSlider.addTarget(self, action: #selector(handleMinPriceChange), for: .valueChanged)
            priceRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxPriceChange), for: .valueChanged)
            
            priceRangeCell.minLabel.text = "Min \(store?.minSeekingPrice ?? 0)"
            priceRangeCell.maxLabel.text = "Max \(store?.maxSeekingPrice ?? 0)"
            priceRangeCell.minSlider.value = Float(store?.minSeekingPrice ?? 0)
            priceRangeCell.maxSlider.value = Float(store?.maxSeekingPrice ?? 0)
            return priceRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = store?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Category"
            cell.textField.text = store?.category
            cell.textField.addTarget(self, action: #selector(handleCategoryChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Price"
            cell.textField.addTarget(self, action: #selector(handlePriceChange), for: .editingChanged)
            if let price = store?.price {
                cell.textField.text = String(price)
            }
        default:
            cell.textField.placeholder = "Enter Description"
            cell.textField.text = store?.description
            cell.textField.addTarget(self, action: #selector(handleDescriptionChange), for: .editingChanged)
        }
        return cell
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField){
        self.store?.name = textField.text
        
    }
    
    @objc fileprivate func handleCategoryChange(textField: UITextField){
        self.store?.category = textField.text
    }
    
    @objc fileprivate func handlePriceChange(textField: UITextField){
        self.store?.price = Int(textField.text ?? "")
    }
    
    @objc fileprivate func handleDescriptionChange(textField: UITextField){
        self.store?.description = textField.text
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleCancel))
            
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
        navigationController?.navigationBar.tintColor = .gold()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gold()]
    }
    
    @objc fileprivate func handleLogout(){
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String: Any] = [
            "uid": uid,
            "storeName": store?.name ?? "",
            "imageUrl1": store?.imageUrl1 ?? "",
            "imageUrl2": store?.imageUrl2 ?? "",
            "imageUrl3": store?.imageUrl3 ?? "",
            "price": store?.price ?? 0,
            "category": store?.category ?? "",
            "description": store?.description ?? "",
            "minSeekingPrice": store?.minSeekingPrice ?? 0,
            "maxSeekingPrice": store?.maxSeekingPrice ?? 200
            
        ]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        Database.database().reference().child("stores").child(uid).updateChildValues(docData) { (error, ref) in
            hud.dismiss()
            if let error = error {
                print("Failed to save store settings:", error)
                return
            }
            print("Finish saving store info")
            self.dismiss(animated: true, completion: {
                print("Dismissal complete")
                self.delegate?.didSaveSetting()
               
            })
        }
        
//        Firestore.firestore().collection("stores").document(uid).setData(docData) { (err) in
//            hud.dismiss()
//            if let err = err {
//                print("Failed to save store settings:", err)
//                return
//            }
//            print("Finish saving store info")
//            self.dismiss(animated: true, completion: {
//                print("Dismissal complete")
//                self.delegate?.didSaveSetting()
////                settingController.fetchCurrentUser()
//            })
        
//        }
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    

    

}
