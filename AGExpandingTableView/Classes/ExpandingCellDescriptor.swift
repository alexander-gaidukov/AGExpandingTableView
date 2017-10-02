//
//  CellDescriptor.swift
//  PaperCell
//
//  Created by Alexandr Gaidukov on 21/09/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

public struct ExpandingCellDescriptor {
    let reuseIdentifier: String
    let headerViewClass: UIView.Type
    let containerViewClass: UIView.Type
    let configure: (UIView, UIView) -> ()
    
    public init<Header: UIView, Container: UIView>(reuseIdentifier: String, configure: @escaping (Header, Container) -> ()) {
        self.reuseIdentifier = reuseIdentifier
        self.headerViewClass = Header.self
        self.containerViewClass = Container.self
        
        self.configure = { header, container in
            configure(header as! Header, container as! Container)
        }
    }
}

public protocol ExpandingCellConfigurationItem {
    var cellDescriptor: ExpandingCellDescriptor { get }
}
