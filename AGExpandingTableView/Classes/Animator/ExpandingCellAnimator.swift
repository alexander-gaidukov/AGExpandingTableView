//
//  DetailedCellAnimator.swift
//  PaperCell
//
//  Created by Alexandr Gaidukov on 25/09/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import Foundation

protocol ExpandingCellAnimator {
    func prepareForAnimation(cell: ExpandingCell, isExpand: Bool)
    func performAnimation(cell: ExpandingCell, duration: TimeInterval, isExpand: Bool)
}
