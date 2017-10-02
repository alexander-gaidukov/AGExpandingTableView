//
//  PaperCellTableView.swift
//  PaperCell
//
//  Created by Alexandr Gaidukov on 21/09/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

public class ExpandingTableView: UITableView {
    
    public var autoupdate: Bool = true
    
    public var cellOffsets: UIEdgeInsets {
        get {
            return expandingDataSource.cellOffsets
        }
        
        set {
            expandingDataSource.cellOffsets = newValue
        }
    }
    
    public var items: [ExpandingCellConfigurationItem] {
        get {
            return expandingDataSource.items
        }
        
        set {
            expandingDataSource.items = newValue
            if autoupdate {
                reloadData()
            }
        }
    }
    
    public var expandingDataSource: ExpandingTableViewDataSource = ExpandingTableViewDataSource() {
        willSet {
            newValue.items = items
            newValue.cellOffsets = cellOffsets
        }
        
        didSet {
            dataSource = expandingDataSource
        }
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        separatorStyle = .none
        dataSource = expandingDataSource
        estimatedRowHeight = UITableViewAutomaticDimension
        rowHeight = UITableViewAutomaticDimension
    }
    
    public func toggleCell(at indexPath: IndexPath, animation: ExpandingCellAnimation? = nil, duration: TimeInterval = 0) {
        
        if let cell = cellForRow(at: indexPath) as? ExpandingCell {
            let isExpand = expandingDataSource.expandOrCollapse(at: indexPath)
            cell.toggle(animation: animation, duration: duration, isExpand: isExpand) {[unowned self] in
                self.beginUpdates()
                self.endUpdates()
            }
        }
    }
}
