//
//  WDRefreshAnimator.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/5.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

class WDAnimatorView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(titleLabel)
        addSubview(activityIndicatorView)
        
        let leftActivityConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: .Right, relatedBy: .Equal, toItem: titleLabel, attribute: .Left, multiplier: 1, constant: -10)
        let centerActivityConstraint = NSLayoutConstraint(item: activityIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        
        let leftTitleConstraint = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerTitleConstraint = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: titleLabel, attribute: .CenterY, multiplier: 1, constant: 0)
        
        addConstraints([leftActivityConstraint, centerActivityConstraint, leftTitleConstraint, centerTitleConstraint])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class WDRefreshAnimator: WDRefreshViewDelegate {
    
    let animatorView: WDAnimatorView
    
    init(frame: CGRect) {
        animatorView = WDAnimatorView(frame: frame)
    }
    
    func pullToRefreshAnimationDidStart(WDRefreshView: UIView) {
        animatorView.activityIndicatorView.startAnimating()
        WDRefreshView.isKindOfClass(WDRefreshHeaderView) ? (animatorView.titleLabel.text = STARTREFRESH) : (animatorView.titleLabel.text = STARTLOAD)
    }
    
    func pullToRefreshAnimationDidEnd(WDRefreshView: UIView) {
        animatorView.activityIndicatorView.stopAnimating()
        animatorView.titleLabel.text = ""
    }
    
    func pullToRefresh(WDRefreshView: UIView, progressDidChange progress: CGFloat) {
        
    }
    
    func pullToRefresh(WDRefreshView: UIView, stateDidChange state: WDRefreshState) {
        WDRefreshView.isKindOfClass(WDRefreshHeaderView) ? (animatorView.titleLabel.font = UIFont.systemFontOfSize(LABELFONTSIZE_HEADER)) :(animatorView.titleLabel.font = UIFont.systemFontOfSize(LABELFONTSIZE_FOOTER))
        switch state {
        case .loading:
            WDRefreshView.isKindOfClass(WDRefreshHeaderView) ? (animatorView.titleLabel.text = STARTREFRESH) : (animatorView.titleLabel.text = STARTLOAD)
        case .pulling:
            WDRefreshView.isKindOfClass(WDRefreshHeaderView) ? (animatorView.titleLabel.text = PULLTOREFRESH) : (animatorView.titleLabel.text = PULLTOLOAD)
        case .releaseToRefresh:
            WDRefreshView.isKindOfClass(WDRefreshHeaderView) ? (animatorView.titleLabel.text = RELEASETOREFRESH) : (animatorView.titleLabel.text = RELEASETOLOAD)
        case .noMoreData:
            WDRefreshView.isKindOfClass(WDRefreshHeaderView) ? (animatorView.titleLabel.text = "") : (animatorView.titleLabel.text = NOMOREDATA)
        }
    }
}
