//
//  ExpandingTableViewDataSource.swift
//  Pods
//
//  Created by Alexander Gaidukov on 9/26/17.
//
//

import Foundation

open class ExpandingTableViewDataSource: NSObject, UITableViewDataSource {
    
    var items: [ExpandingCellConfigurationItem] = []
    var cellOffsets = UIEdgeInsets(top: 7.0, left: 20.0, bottom: 7.0, right: 20.0)
    
    private var reuseIdentifiers: Set<String> = []
    private var expandedIndexPaths: Set<IndexPath> = []
    
    func expandOrCollapse(at indexPath: IndexPath) -> Bool {
        if expandedIndexPaths.contains(indexPath) {
            expandedIndexPaths.remove(indexPath)
            return false
        }
        
        expandedIndexPaths.insert(indexPath)
        return true
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let descriptor = item.cellDescriptor
        
        if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
            tableView.register(ExpandingCell.self, forCellReuseIdentifier: descriptor.reuseIdentifier)
            reuseIdentifiers.insert(descriptor.reuseIdentifier)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath) as! ExpandingCell
        
        if cell.headerView == nil && cell.containerView == nil {
            cell.offsets = cellOffsets
            cell.headerView = descriptor.headerViewClass.instance()
            cell.containerView = descriptor.containerViewClass.instance()
        }
        
        descriptor.configure(cell.headerView, cell.containerView)
        
        let isExpanded = expandedIndexPaths.contains(indexPath)
        cell.toggle(isExpand: isExpanded)
        
        return cell
    }
}
