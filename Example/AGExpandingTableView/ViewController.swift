//
//  ViewController.swift
//  ExpandingTableView
//
//  Created by alexander-gaidukov on 09/25/2017.
//  Copyright (c) 2017 alexander-gaidukov. All rights reserved.
//

import UIKit
import AGExpandingTableView

class MyExpandingTableViewDataSource: ExpandingTableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Organizations and Users List"
    }
}

class ViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: ExpandingTableView!
    
    var items: [ExpandingCellConfigurationItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var users: [User] = []
        
        for _ in 0..<10 {
            
            let user = User(coverImage: #imageLiteral(resourceName: "Cover"), avatarImage: #imageLiteral(resourceName: "Avatar"), firstName: "John", lastName: "Doe", address: "New Yourk, USA", starsCount: 10, contactsCount: 124, postsCount: 17)
            let userItem = UserCellConfigurationItem(user: user) { user in
                print("Send message to \(user.firstName) \(user.lastName)")
            }
            users.append(user)
            items.append(userItem)
        }
        
        let organization = Organization(coverImage: #imageLiteral(resourceName: "Organization cover"), logoImage: #imageLiteral(resourceName: "Logo"), title: "Secret organization", address: "San Francisco, CA", employees: users)
        let organizationItem = OrganizationCellConfigurationItem(organization: organization) { organization in
            print("Send CV to \(organization.title)")
        }
        items.insert(organizationItem, at: 0)
        
        tableView.expandingDataSource = MyExpandingTableViewDataSource()
        tableView.items = items
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.toggleCell(at: indexPath, animation: .folding(count: 4, backsideColor: #colorLiteral(red: 0.799816725, green: 0.931905428, blue: 0.9764705896, alpha: 1)), duration: 1.0)
        //self.tableView.toggleCell(at: indexPath, animation: .flipAndSlide, duration: 1.0)
    }
}

