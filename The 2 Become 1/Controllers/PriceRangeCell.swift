//
//  PriceTableCell.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/4/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class PriceRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .gold()
        slider.minimumValue = 0
        slider.maximumValue = 15000
    
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = PriceRangeLabel()
        label.text = "Min 0"
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = PriceRangeLabel()
        label.text = "Max 0"
        return label
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .gold()
        slider.minimumValue = 0
        slider.maximumValue = 15000
        return slider
    }()
    
    class PriceRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 100, height: 0)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews:[minLabel, minSlider]),
            UIStackView(arrangedSubviews:[maxLabel, maxSlider])
        ])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        addSubview(overallStackView)
        overallStackView.anchorForSwipe(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
