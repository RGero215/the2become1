//
//  ChatroomMenuCell.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 12/7/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class ChatroomMenuCell: UITableViewCell {
    
    let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bgView)
        selectionStyle = .none
        bgView.fillSuperview(padding: .init(top: 0, left: 8, bottom: 0, right: 8))
        sendSubviewToBack(bgView)
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        bgView.isHidden = !selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
