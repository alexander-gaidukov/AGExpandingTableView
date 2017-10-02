//
//  User.swift
//  ExpandingTableView
//
//  Created by Alexander Gaidukov on 9/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import AGExpandingTableView

struct User {
    var coverImage: UIImage
    var avatarImage: UIImage
    var firstName: String
    var lastName: String
    var address: String
    var starsCount: Int
    var contactsCount: Int
    var postsCount: Int
}

struct UserCellConfigurationItem: ExpandingCellConfigurationItem {
    
    var user: User
    var sendMessage: (User) -> ()
    
    var cellDescriptor: ExpandingCellDescriptor {
        return ExpandingCellDescriptor(reuseIdentifier: "UserCell") { (header: UserHeaderView, container: UserContainerView) in
            header.configure(item: self)
            container.configure(item: self)
        }
    }
}
