//
//  RegistrationViewModel.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/29/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var imageObserver: ((UIImage?) -> ())?
    
    var storeName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()){
        guard let email = email else {return}
        guard let password = password else {return}
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                completion(err)
                return
            }
            print("Successfully register store:", res?.user.uid ?? "")
            
            self.saveImageToFirebase(completion: completion)
            
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()){
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/brands_images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                print("Download url of our image is:", url?.absoluteString ?? "")
                // store the download url into firestore
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
                
                completion(nil)
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["storeName": storeName ?? "", "uid": uid, "imageUrl1": imageUrl]
//        Firestore.firestore().collection("stores").document(uid).setData(docData) { (err) in
//            if let err = err {
//                completion(err)
//                return
//            }
//            completion(nil)
        
//        }
        
        Database.database().reference().child("stores").child(uid).setValue(docData)
    }

    fileprivate func checkFormValidity(){
        let isFormValid = storeName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    
    
}
