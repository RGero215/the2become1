//
//  Vendors.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/28/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Store: ProducesCardViewModel {
    var name: String?
    var price: Int?
    var category: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var description: String?
    var stock: Bool?
    var uid: String?
    
    var minSeekingPrice: Int?
    var maxSeekingPrice: Int?
    
    init(dictionary: [String:Any]){
        let store = dictionary["storeName"] as? String ?? ""
        self.name = store
        self.price = dictionary["price"] as? Int
        self.category = dictionary["category"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.stock = true
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingPrice = dictionary["minSeekingPrice"] as? Int
        self.maxSeekingPrice = dictionary["maxSeekingPrice"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedStringShadow = NSShadow()
        let priceString = price != nil ? "\(price!)" : ""
        let categoryString = category != nil ? "\(category!)" : ""
        let dollarSign = price != nil ? "$" : ""
        
        attributedStringShadow.shadowBlurRadius = 5.0
        attributedStringShadow.shadowColor = UIColor.black
        let attributedText = NSMutableAttributedString(string: name ?? ""
            , attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .heavy), .shadow: attributedStringShadow])
        
        attributedText.append(NSAttributedString(string: " \(dollarSign)\(priceString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular), .shadow: attributedStringShadow]))
        
        attributedText.append(NSAttributedString(string: "\n\(categoryString)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular), .shadow: attributedStringShadow]))
        
        var imageUrls = [String]()
        if let url = imageUrl1 {imageUrls.append(url)}
        if let url = imageUrl2 {imageUrls.append(url)}
        if let url = imageUrl3 {imageUrls.append(url)}
        
        
        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
