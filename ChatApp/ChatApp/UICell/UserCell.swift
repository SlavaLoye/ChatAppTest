//
//  UserCell.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 25.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    init(cider aDecoder: NSCoder) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

