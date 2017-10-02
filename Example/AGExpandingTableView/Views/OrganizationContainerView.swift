//
//  ContentView.swift
//  PaperCell
//
//  Created by Alexander Gaidukov on 9/22/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

class OrganizationContainerView: UIView {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var employeesLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var employeesCollectionView: UICollectionView!
    
    fileprivate var organizationItem: OrganizationCellConfigurationItem?
    
    fileprivate let cellIdentifier: String = "EmployeeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2.0
        
        employeesCollectionView.register(UINib(nibName: String(describing: EmployeeCell.self), bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func configure(item: OrganizationCellConfigurationItem) {
        
        organizationItem = item
        
        coverImageView.image = item.organization.coverImage
        logoImageView.image = item.organization.logoImage
        titleLabel.text = item.organization.title
        employeesLabel.text = "Employees: \(item.organization.employees.count)"
        addressLabel.text = item.organization.address
    }
    
    @IBAction private func sendCV() {
        guard let item = organizationItem else {
            return
        }
        
        item.sendCV(item.organization)
    }
}

extension OrganizationContainerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return organizationItem?.organization.employees.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EmployeeCell
        cell.imageView.image = organizationItem!.organization.employees[indexPath.item].avatarImage
        return cell
    }
}

extension OrganizationContainerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40.0, height: 40.0)
    }
}
