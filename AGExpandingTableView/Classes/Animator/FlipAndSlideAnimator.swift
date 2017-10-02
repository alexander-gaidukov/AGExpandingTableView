//
//  FlipAndSlideAnimator.swift
//  PaperCell
//
//  Created by Alexandr Gaidukov on 25/09/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

final class FlipAndSlideAnimator: NSObject, ExpandingCellAnimator {
    func prepareForAnimation(cell: ExpandingCell, isExpand: Bool) {
        
        cell.animationView.layer.masksToBounds = true
        
        let headerViewSnapshot = cell.headerView.snapshot(fromRect: cell.headerView.bounds)
        let containerViewTopSnapshot = cell.containerView.snapshot(fromRect: CGRect(origin: .zero, size: CGSize(width: cell.containerView.frame.width, height: cell.headerView.frame.height)))
        let containerViewBottomSnapshot = cell.containerView.snapshot(fromRect: CGRect(x: 0.0, y: cell.headerView.frame.height, width: cell.containerView.frame.width, height: cell.containerView.frame.height - cell.headerView.frame.height))
        
        headerViewSnapshot.alpha = isExpand ? 1.0 : 0.0
        containerViewTopSnapshot.alpha = isExpand ? 0.0 : 1.0
        containerViewBottomSnapshot.alpha = isExpand ? 0.0 : 1.0
        containerViewBottomSnapshot.frame.origin.y = isExpand ? (cell.headerView.frame.height - containerViewBottomSnapshot.frame.height) : cell.headerView.frame.height
        
        cell.animationView.addSubview(containerViewBottomSnapshot)
        cell.animationView.addSubview(containerViewTopSnapshot)
        cell.animationView.addSubview(headerViewSnapshot)
        
        cell.animateViews = [headerViewSnapshot, containerViewTopSnapshot, containerViewBottomSnapshot]
    }
    
    private func slideAnimation(byValue: CGFloat, duration: TimeInterval, delay: TimeInterval) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = duration
        animation.byValue = byValue
        animation.delegate = self
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime() + delay
        return animation
    }
    
    private func flipAnimation(fromValue: CGFloat, toValue: CGFloat, timingFunction: String, duration: TimeInterval, delay: TimeInterval) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.x")
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.delegate = self
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime() + delay
        
        return animation
    }
    
    func performAnimation(cell: ExpandingCell, duration: TimeInterval, isExpand: Bool) {
        
        if !isExpand {
            cell.animateViews.reverse()
        }
        
        var fromValue: CGFloat = 0.0
        var toValue: CGFloat = isExpand ? -CGFloat.pi / 2.0 : CGFloat.pi / 2.0
        let animDuration = duration / TimeInterval(4)
        var timingFunction = kCAMediaTimingFunctionEaseIn
        var delay: TimeInterval = 0
        
        for i in 0...2 {
            
            let view = cell.animateViews[i]
            var animation: CABasicAnimation
            
            var isFlip: Bool = false
            
            if (isExpand && i == 2) || (!isExpand && i == 0) {
                animation = slideAnimation(byValue: isExpand ? view.frame.height : -view.frame.height, duration: duration / TimeInterval(2), delay: delay)
                delay += duration / TimeInterval(2)
            } else {
                animation = flipAnimation(fromValue: fromValue, toValue: toValue, timingFunction: timingFunction, duration: animDuration, delay: delay)
                delay += animDuration
                isFlip = true
            }
            
            animation.setValue(view, forKey: "view")
            animation.setValue(isExpand ? i == 0 : i != 2, forKey: "hide")
            animation.setValue(isExpand, forKey: "isExpand")
            animation.setValue(cell, forKey: "cell")
            
            view.layer.add(animation, forKey: "rotation")
            
            if isFlip {
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
}

extension FlipAndSlideAnimator: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        guard let view = anim.value(forKey: "view") as? UIView else {
                return
        }
        
        view.layer.allowsEdgeAntialiasing = true
        view.alpha = 1.0
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let view = anim.value(forKey: "view") as? UIView,
            let hide = anim.value(forKey: "hide") as? Bool,
            let isExpand = anim.value(forKey: "isExpand") as? Bool,
            let cell = anim.value(forKey: "cell") as? ExpandingCell else {
                return
        }
        
        view.alpha = hide ? 0.0 : 1.0
        view.layer.removeAllAnimations()
        
        if cell.animateViews.last == view {
            cell.animationDidFinish(isExpand: isExpand)
        }
    }
}
