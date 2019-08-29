//
//  PersonCell.swift
//  Created by Techmaster on 3/22/19.
//  Copyright © 2019 Techmaster. All rights reserved.
//

import Foundation
import Stevia
class PersonCell: UITableViewCell {
    
    let avatar = UIImageView()
    let name = UILabel()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sv(
            avatar,
            name.style(nameStyle)
        )
        self.height(90)
        
        avatar.size(80).centerVertically()
        align(horizontally: |-20-avatar-50-name-20-|)
       // avatar.layer.cornerRadius = 40
     //   avatar.clipsToBounds = true
    }
    
    func nameStyle(l:UILabel) {
        l.font = .systemFont(ofSize: 24)
        l.textColor = .black
    }
}
