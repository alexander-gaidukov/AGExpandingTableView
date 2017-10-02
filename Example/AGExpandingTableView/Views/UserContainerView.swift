//
//  ContentView.swift
//  PaperCell
//
//  Created by Alexander Gaidukov on 9/22/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

class UserContainerView: UIView {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var contactsLabel: UILabel!
    @IBOutlet private weak var postsLabel: UILabel!
    
    private var userItem: UserCellConfigurationItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2.0
    }
    
    func configure(item: UserCellConfigurationItem) {
        
        userItem = item
        
        coverImageView.image = item.user.coverImage
        avatarImageView.image = item.user.avatarImage
        firstNameLabel.text = item.user.firstName
        lastNameLabel.text = item.user.lastName
        addressLabel.text = item.user.address
        starsLabel.text = "Stars:\n\(item.user.starsCount)"
        contactsLabel.text = "Contacts:\n\(item.user.contactsCount)"
        postsLabel.text = "Posts:\n\(item.user.postsCount)"
    }
    
    @IBAction private func sendMessage() {
        guard let item = userItem else {
            return
        }
        
        item.sendMessage(item.user)
    }
}
