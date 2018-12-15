//
//  Advertiser.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/28/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedStringShadow = NSShadow()
//        attributedStringShadow.shadowOffset =
        attributedStringShadow.shadowBlurRadius = 5.0
        attributedStringShadow.shadowColor = UIColor.black
        
        let attributedString = NSMutableAttributedString(string: title
            , attributes: [.font : UIFont.systemFont(ofSize: 34, weight: .heavy), .foregroundColor: UIColor.white, .shadow: attributedStringShadow])
        attributedString.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold ),.shadow: attributedStringShadow]))
        
        
        return CardViewModel(imageNames: [posterPhotoName], attributedString: attributedString, textAlignment: .center)
    }
}
