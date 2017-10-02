//
//  HeaderView.swift
//  PaperCell
//
//  Created by Alexander Gaidukov on 9/22/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

class OrganizationHeaderView: UIView {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var employeesLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2.0
    }
    
    func configure(item: OrganizationCellConfigurationItem) {
        coverImageView.image = item.organization.coverImage
        logoImageView.image = item.organization.logoImage
        titleLabel.text = item.organization.title
        employeesLabel.text = "Employees: \(item.organization.employees.count)"
        addressLabel.text = item.organization.address
    }
}
