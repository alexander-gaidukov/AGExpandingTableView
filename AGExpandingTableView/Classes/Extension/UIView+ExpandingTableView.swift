//
//  UIView+.swift
//  PaperCell
//
//  Created by Alexandr Gaidukov on 22/09/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

extension UIView {
    
    class func instance() -> Self {
        return createInstance(type: self)
    }
    
    private class func createInstance<T: UIView>(type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(String(describing: type), owner: nil, options: nil)?.first as? T {
            return view
        }
        
        return type.init(frame: .zero)
    }
    
    func snapshot(fromRect rect: CGRect) -> UIView {
        let result = resizableSnapshotView(from: rect, afterScreenUpdates: true, withCapInsets: .zero)!
        result.backgroundColor = .clear
        return result
    }
}
