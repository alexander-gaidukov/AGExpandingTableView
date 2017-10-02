//
//  CATransform3D+.swift
//  Pods
//
//  Created by Alexander Gaidukov on 9/26/17.
//
//

import Foundation

extension CATransform3D {
    static let perspective: CATransform3D = {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        return transform
    }()
}
