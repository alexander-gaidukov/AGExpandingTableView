//
//  Organization.swift
//  ExpandingTableView
//
//  Created by Alexander Gaidukov on 9/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import AGExpandingTableView

struct Organization {
    var coverImage: UIImage
    var logoImage: UIImage
    var title: String
    var address: String
    var employees: [User]
}

struct OrganizationCellConfigurationItem: ExpandingCellConfigurationItem {
    var organization: Organization
    var sendCV: (Organization) -> ()
    
    var cellDescriptor: ExpandingCellDescriptor {
        return ExpandingCellDescriptor(reuseIdentifier: "OrganizationCell") { (header: OrganizationHeaderView, container: OrganizationContainerView) in
            header.configure(item: self)
            container.configure(item: self)
        }
    }
}
