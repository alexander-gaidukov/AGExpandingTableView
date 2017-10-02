//
//  FoldAnimator.swift
//  PaperCell
//
//  Created by Alexandr Gaidukov on 25/09/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

final class FoldAnimator: NSObject, ExpandingCellAnimator {
    
    private let count: Int
    private let backsideColor: UIColor
    
    init(count: Int, backsideColor: UIColor) {
        self.count = count
        self.backsideColor = backsideColor
    }
    
    func prepareForAnimation(cell: ExpandingCell, isExpand: Bool) {
        
        cell.animationView.layer.masksToBounds = false
        
        let headerSnapshot = cell.headerView.snapshot(fromRect: cell.headerView.bounds)
        headerSnapshot.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        headerSnapshot.frame.origin.y += headerSnapshot.frame.height / 2.0
        headerSnapshot.alpha = isExpand ? 1.0 : 0.0
        
        let firstPartSnapshot = cell.containerView.snapshot(fromRect: CGRect(origin: .zero, size: CGSize(width: cell.containerView.bounds.width, height: cell.headerView.bounds.height)))
        
        let secondPartSnapshot = cell.containerView.snapshot(fromRect: CGRect(origin: CGPoint(x: 0.0, y: cell.headerView.frame.height), size: CGSize(width: cell.containerView.bounds.width, height: min(cell.headerView.bounds.height, cell.containerView.frame.height - cell.headerView.frame.height))))
        secondPartSnapshot.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        secondPartSnapshot.frame.origin.y = cell.headerView.frame.height
        secondPartSnapshot.alpha = isExpand ? 0.0 : 1.0
        
        cell.animationView.addSubview(firstPartSnapshot)
        cell.animationView.addSubview(secondPartSnapshot)
        cell.animationView.addSubview(headerSnapshot)
        
        cell.animateViews.append(headerSnapshot)
        cell.animateViews.append(secondPartSnapshot)
        
        var currentHeight = firstPartSnapshot.frame.height + secondPartSnapshot.frame.height
        let diff = cell.containerView.frame.height - currentHeight
        
        if diff > 0 {
            let itemsCount = max(count - 1, 1)
            let step = diff / CGFloat(itemsCount)
            
            for i in 0..<itemsCount + 1 {
                
                if i == 0 {
                    let backView = BacksideView(frame: CGRect(x: 0.0, y: secondPartSnapshot.frame.height - step, width: secondPartSnapshot.frame.width, height: step))
                    backView.backgroundColor = backsideColor
                    backView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                    backView.frame.origin.y += backView.frame.height / 2.0
                    backView.alpha = isExpand ? 1.0 : 0.0
                    secondPartSnapshot.addSubview(backView)
                    secondPartSnapshot.layer.masksToBounds = false
                    secondPartSnapshot.layer.sublayerTransform = .perspective
                    cell.animateViews.append(backView)
                } else if i == itemsCount {
                    let rotationView = cell.containerView.snapshot(fromRect: CGRect(x: 0.0, y: currentHeight, width: cell.containerView.bounds.width, height: step))
                    rotationView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                    rotationView.frame.origin.y = currentHeight
                    rotationView.alpha = isExpand ? 0.0 : 1.0
                    cell.animationView.addSubview(rotationView)
                    cell.animateViews.append(rotationView)
                } else {
                    let staticView = cell.containerView.snapshot(fromRect: CGRect(x: 0.0, y: currentHeight, width: cell.containerView.bounds.width, height: step))
                    staticView.frame.origin.y = currentHeight
                    staticView.alpha = isExpand ? 0.0 : 1.0
                    
                    let firstBackView = BacksideView(frame: staticView.frame)
                    firstBackView.backgroundColor = backsideColor
                    firstBackView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                    firstBackView.frame.origin.y -= firstBackView.frame.height / 2.0
                    firstBackView.alpha = 0.0
                    
                    let backView = BacksideView(frame: staticView.frame)
                    backView.backgroundColor = backsideColor
                    backView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                    backView.frame.origin.y += backView.frame.height / 2.0
                    backView.alpha = 0.0
                    backView.coveredView = staticView
                    
                    cell.animationView.addSubview(staticView)
                    cell.animationView.addSubview(backView)
                    cell.animationView.addSubview(firstBackView)
                    
                    cell.animateViews.append(firstBackView)
                    cell.animateViews.append(backView)
                    
                    currentHeight += step
                }
            }
        }
    }
    
    func performAnimation(cell: ExpandingCell, duration: TimeInterval, isExpand: Bool) {
        if !isExpand {
            cell.animateViews.reverse()
        }
        
        var fromValue: CGFloat = 0.0
        var toValue: CGFloat = isExpand ? -CGFloat.pi / 2.0 : CGFloat.pi / 2.0
        let animDuration = duration / TimeInterval(cell.animateViews.count)
        var timingFunction = kCAMediaTimingFunctionEaseIn
        
        var delay: TimeInterval = 0
        
        for i in 0..<cell.animateViews.count {
            
            let animation = CABasicAnimation(keyPath: "transform.rotation.x")
            animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
            animation.duration = animDuration
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.beginTime = CACurrentMediaTime() + delay
            
            
            let view = cell.animateViews[i]
            
            let hide = isExpand ? (i == 0 || view is BacksideView) : (i != cell.animateViews.count - 3)
            
            animation.setValue(view, forKey: "view")
            animation.setValue(hide, forKey: "hide")
            animation.setValue(isExpand, forKey: "isExpand")
            animation.setValue(cell, forKey: "cell")
            
            view.layer.add(animation, forKey: "rotation.x")
            
            delay += animDuration
            fromValue = fromValue == 0.0 ? CGFloat.pi / 2.0 : CGFloat(0.0)
            toValue = toValue == 0.0 ? -CGFloat.pi / 2.0 : CGFloat(0.0)
            timingFunction = timingFunction == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn
            
            if !isExpand {
                fromValue = -fromValue
                toValue = -toValue
            }
        }
    }
}

extension FoldAnimator: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        guard let view = anim.value(forKey: "view") as? UIView,
            let isExpand = anim.value(forKey: "isExpand") as? Bool else {
                return
        }

        view.alpha = 1.0
        view.layer.allowsEdgeAntialiasing = true
        
        if let backView = view as? BacksideView, isExpand {
            backView.coveredView?.alpha = 1.0
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let view = anim.value(forKey: "view") as? UIView,
            let hide = anim.value(forKey: "hide") as? Bool,
            let isExpand = anim.value(forKey: "isExpand") as? Bool,
            let cell = anim.value(forKey: "cell") as? ExpandingCell else {
                return
        }
        
        if let backView = view as? BacksideView, !isExpand {
            backView.coveredView?.alpha = 0.0
        }
        
        view.alpha = hide ? 0.0 : 1.0
        view.layer.removeAllAnimations()
        
        if cell.animateViews.last == view {
            cell.animationDidFinish(isExpand: isExpand)
        }
    }
}

fileprivate final class BacksideView: UIView {
    var coveredView: UIView?
}
