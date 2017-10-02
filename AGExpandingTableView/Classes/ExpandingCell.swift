//
//  PaperCell.swift
//  PaperCell
//
//  Created by Alexandr Gaidukov on 21/09/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

import UIKit

public enum ExpandingCellAnimation {
    case folding(count: Int, backsideColor: UIColor)
    case flipAndSlide
}

extension ExpandingCellAnimation {
    var animator: ExpandingCellAnimator {
        switch  self {
        case .folding(let count, let color):
            return FoldAnimator(count: count, backsideColor: color)
        default:
            return FlipAndSlideAnimator()
        }
    }
}

class ExpandingCell: UITableViewCell {
    
    private var containerViewBottomConstraint: NSLayoutConstraint!
    private var headerViewBottomConstraint: NSLayoutConstraint!
    
    var animationView: UIView!
    
    var offsets = UIEdgeInsets(top: 7.0, left: 20.0, bottom: 7.0, right: 20.0)
    
    var animateViews: [UIView] = []
    
    var isAnimating: Bool = false
    
    private var zPosition: CGFloat!
    
    private var animationComleted: (() -> ())?
    
    var headerView: UIView! {
        didSet {
            
            contentView.addSubview(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -offsets.top).isActive = true
            contentView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: -offsets.left).isActive = true
            contentView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: offsets.right).isActive = true
            
            headerViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: offsets.bottom)
            headerViewBottomConstraint.priority = UILayoutPriority(rawValue: 500)
            headerViewBottomConstraint.isActive = true
            
            organizeView()
        }
    }
    
    var containerView: UIView! {
        didSet {
            
            contentView.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -offsets.top).isActive = true
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -offsets.left).isActive = true
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: offsets.right).isActive = true
            
            containerViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: offsets.bottom)
            containerViewBottomConstraint.priority = .defaultLow
            containerViewBottomConstraint.isActive = true
            
            organizeView()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func organizeView() {
        if let containerView = containerView, let headerView = headerView {
            
            assert(containerView.frame.height > headerView.frame.height, "Detail View should be bigger than Header View")
            
            containerView.alpha = 0.0
            
            if animationView == nil {
                animationView = UIView(frame: .zero)
                animationView.backgroundColor = .clear
                animationView.layer.masksToBounds = false
                animationView.layer.cornerRadius = containerView.layer.cornerRadius
                contentView.addSubview(animationView)
                animationView.alpha = 0.0
                animationView.translatesAutoresizingMaskIntoConstraints = false
                containerView.topAnchor.constraint(equalTo: animationView.topAnchor).isActive = true
                containerView.leadingAnchor.constraint(equalTo: animationView.leadingAnchor).isActive = true
                containerView.trailingAnchor.constraint(equalTo: animationView.trailingAnchor).isActive = true
                containerView.bottomAnchor.constraint(equalTo: animationView.bottomAnchor).isActive = true
            }
            
            
            contentView.bringSubview(toFront: headerView)
        }
    }
    
    private func commonAnimationPerparation() {
        zPosition = layer.zPosition
        layer.zPosition = 1000
        contentView.bringSubview(toFront: animationView)
        containerView.alpha = 1.0
        headerView.alpha = 1.0
    }
    
    private func commitAnimationPreparation(isExpand: Bool) {
        
        animationView.layer.sublayerTransform = .perspective
        
        animationView.alpha = 1.0
        headerView.alpha = 0.0
        containerView.alpha = 0.0
        containerViewBottomConstraint.priority = isExpand ? .defaultHigh : .defaultLow
        headerViewBottomConstraint.isActive = !isExpand
    }
    
    func toggle(animation: ExpandingCellAnimation? = nil, duration: TimeInterval = 0, isExpand: Bool, completion: @escaping () -> () = {}) {
        
        guard !isAnimating else {
            return
        }
        
        if let animation = animation {
            
            animationComleted = completion
            
            let animator = animation.animator
            // Prepare for animation
            commonAnimationPerparation()
            animator.prepareForAnimation(cell: self, isExpand: isExpand)
            commitAnimationPreparation(isExpand: isExpand)
            
            //Perform animation
            animator.performAnimation(cell: self, duration: duration, isExpand: isExpand)
            
            return
        }
        
        headerView.alpha = isExpand ? 0.0 : 1.0
        containerView.alpha = isExpand ? 1.0 : 0.0
        contentView.bringSubview(toFront: isExpand ? containerView : headerView)
        containerViewBottomConstraint.priority = isExpand ? .defaultHigh : .defaultLow
        headerViewBottomConstraint.isActive = !isExpand
    }
    
    func animationDidFinish(isExpand: Bool) {
        animateViews.removeAll()
        containerView.alpha = isExpand ? 1.0 : 0.0
        headerView.alpha = isExpand ? 0.0 : 1.0
        contentView.bringSubview(toFront: isExpand ? containerView : headerView)
        animationView.alpha = 0.0
        animationView.subviews.forEach{
            $0.removeFromSuperview()
        }
        isAnimating = false
        layer.zPosition = zPosition
        animationComleted?()
    }
}
