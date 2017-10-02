//
//  HeaderView.swift
//  PaperCell
//
//  Created by Alexander Gaidukov on 9/22/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

class UserHeaderView: UIView {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2.0
    }
    
    func configure(item: UserCellConfigurationItem) {
        coverImageView.image = item.user.coverImage
        avatarImageView.image = item.user.avatarImage
        firstNameLabel.text = item.user.firstName
        lastNameLabel.text = item.user.lastName
        addressLabel.text = item.user.address
    }
}
