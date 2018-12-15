//
//  SwipeController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/27/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SwipeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate, UserLoginControllerDelegate {
  
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let baseSlidingController = BaseSlidingController()
    
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    
    var cardViewModels = [CardViewModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    
        topStackView.messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    
        setupLayout()
        fetchCurrentStore()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Kick the user out when log out
        if Auth.auth().currentUser == nil {
            print("ViewDidAppear")
            let storesLoginController = StoresLoginController()
            storesLoginController.delegate = self
            let navController = UINavigationController(rootViewController: storesLoginController)
            present(navController, animated: true, completion: nil)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentStore()
    }

    
    fileprivate var store: Store?
    fileprivate func fetchCurrentStore(){
        // fetch some Firestore
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("stores").child(uid).observe(.value, with: { (snapshot) in
            // fetched our user
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            self.store = Store(dictionary: dictionary)
            self.fetchStoresFromFirestore()
        }) { (err) in
            print(err)
            return
        }

    }
    
    @objc func handleRefresh(){
        fetchStoresFromFirestore()
    }
    
    var lastFetchedStore: Store?
    
    fileprivate func fetchStoresFromFirestore(){
        guard let minPrice = store?.minSeekingPrice, let maxPrice = store?.maxSeekingPrice else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Stores"
        hud.show(in:view)
        
        let query = Database.database().reference().child("stores")
            query.observe(.value, with: { (snapshot) in
            hud.dismiss()
                
                guard let storeDictionary = snapshot.value as? [String:Any] else {return}
                storeDictionary.forEach({ (key, value) in
                   
                    let store = Store(dictionary: value as! [String : Any])


                    if store.uid != Auth.auth().currentUser?.uid {
                        self.setupCardFromStore(store: store)
                        print("Store in card: ", store)
                    }
                })
                
        }) { (err) in
            print("Failed to fetch stores:", err)
            return
        }
    }

        
//        let query = Firestore.firestore().collection("stores").whereField("price", isGreaterThanOrEqualTo: minPrice).whereField("price", isLessThanOrEqualTo: maxPrice)
//            query.getDocuments { (snapshot, err) in
//                hud.dismiss()
//
//            if let err = err {
//                print("Failed to fetch stores:", err)
//                return
//            }
//
//            snapshot?.documents.forEach({ (documenteSnapshot) in
//                let storeDictionary = documenteSnapshot.data()
//                let store = Store(dictionary: storeDictionary)
//
//                if store.uid != Auth.auth().currentUser?.uid {
//                    self.setupCardFromStore(store: store)
//                }
//
//
//            })
//        }
    
    
    fileprivate func setupCardFromStore(store: Store){
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = store.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let storeDetailsController = StoreDetailsController()
        storeDetailsController.cardViewModel = cardViewModel
        present(storeDetailsController, animated: true, completion: nil)
    }
    
    @objc func handleMessage(){
//        let menuController = ChatroomMenuContainerController()
        baseSlidingController.performRightViewCleanUp()
        appDelegate.state = .store
        let messagesVC = UINavigationController(rootViewController: MessagesController())
        baseSlidingController.rightViewController = messagesVC
        baseSlidingController.rightContainer.addSubview(messagesVC.view)
        
        baseSlidingController.addChild(messagesVC)
        print("State before:", appDelegate.state)
        present(baseSlidingController, animated: true)
        
    }
    
    @objc func handleSettings(){
        let settingsController = SettingController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true, completion: nil)
    }
    
    func didSaveSetting() {
        fetchCurrentStore()
    }
    
    fileprivate func setupFirestoreUserCards(){
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchorForSwipe(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}
