//
//  EmployeeCell.swift
//  ExpandingTableView
//
//  Created by Alexander Gaidukov on 9/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class EmployeeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.frame.height / 2.0
    }

}
