//
//  WDRefreshHeaderView.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/5.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

private var KVOContext = "WDRefreshHeaderContext"
private let ContentOffsetKeyPath = "contentOffset"

public class WDRefreshHeaderView: UIView {

    private var scrollViewBouncesDefaultValue: Bool = false
    private var scrollViewInsetsDefaultValue: UIEdgeInsets = UIEdgeInsetsZero
    
    private var animator:WDRefreshViewDelegate
    private var action: () ->Void = {}
    
    private var previousOffset: CGFloat = 0
    
    var loading: Bool = false {
        didSet {
            if loading != oldValue {
                if loading {
                    startAnimating()
                } else {
                    stopAnimating()
                }
            }
        }
    }
    
    
    //MARK: - 生命周期
    
    convenience init(action :() -> Void, frame: CGRect) {
        var bounds = frame
        bounds.origin.y = 0
        let animator = WDRefreshAnimator(frame: bounds)
        self.init(frame: frame, animator: animator)
        self.action = action;
        addSubview(animator.animatorView)
    }
    
    convenience init(action :() -> Void, frame: CGRect, animator: WDRefreshViewDelegate, subview: UIView) {
        self.init(frame: frame, animator: animator)
        self.action = action;
        subview.frame = self.bounds
        addSubview(subview)
    }
    
    convenience init(action :() -> Void, frame: CGRect, animator: WDRefreshViewDelegate) {
        self.init(frame: frame, animator: animator)
        self.action = action;
    }
    
    init(frame: CGRect, animator: WDRefreshViewDelegate) {
        self.animator = animator
        super.init(frame: frame)
        self.autoresizingMask = .FlexibleWidth
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.animator = WDRefreshAnimator(frame: CGRect.zero)
        super.init(coder: aDecoder)
        // Currently it is not supported to load view from nib
    }
    
    deinit {
        let scrollView = superview as? UIScrollView
        scrollView?.removeObserver(self, forKeyPath: ContentOffsetKeyPath, context: &KVOContext)
    }
    
    
    //MARK: - 添加到俯视图时添加监听
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        superview?.removeObserver(self, forKeyPath: ContentOffsetKeyPath, context: &KVOContext)
        if let scrollView = newSuperview as? UIScrollView {
            scrollView.addObserver(self, forKeyPath: ContentOffsetKeyPath, options: .Initial, context: &KVOContext)
            scrollViewBouncesDefaultValue = scrollView.bounces
            scrollViewInsetsDefaultValue = scrollView.contentInset
        }
    }
    
    //MARK: - KVO监测contentoffset
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (context == &KVOContext) {
            if let scrollView = superview as? UIScrollView  where object as? NSObject == scrollView {
                if keyPath == ContentOffsetKeyPath {
                    let offsetWithoutInsets = previousOffset + scrollViewInsetsDefaultValue.top
                    if (offsetWithoutInsets < -self.frame.size.height) {
                        if (scrollView.dragging == false && loading == false) {
                            loading = true
                        } else if (loading) {
                            self.animator.pullToRefresh(self, stateDidChange: .loading)
                        } else {
                            self.animator.pullToRefresh(self, stateDidChange: .releaseToRefresh)
                            animator.pullToRefresh(self, progressDidChange: -offsetWithoutInsets / self.frame.size.height)
                        }
                    } else if (loading) {
                        self.animator.pullToRefresh(self, stateDidChange: .loading)
                    } else if (offsetWithoutInsets < 0) {
                        self.animator.pullToRefresh(self, stateDidChange: .pulling)
                        animator.pullToRefresh(self, progressDidChange: -offsetWithoutInsets / self.frame.size.height)
                    }
                    previousOffset = scrollView.contentOffset.y
                }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

    
    //MARK: - 刷新动画开始和结束
    func startAnimating(){
        let scrollView = superview as! UIScrollView
        var insets = scrollView.contentInset
        insets.top += self.frame.size.height
        
        scrollView.contentOffset.y = previousOffset
        scrollView.bounces = false
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: { 
            scrollView.contentInset = insets
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insets.top)
            }) { finished in
                weakSelf!.animator.pullToRefreshAnimationDidStart(self)
                weakSelf!.action()
        }
    }
    
    func stopAnimating(){
        NSNotificationCenter.defaultCenter().postNotificationName(NOMOREDATANOTIFICATION, object: nil)
        self.animator.pullToRefreshAnimationDidEnd(self)
        let scrollView = superview as! UIScrollView
        scrollView.bounces = self.scrollViewBouncesDefaultValue
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: {
            scrollView.contentInset = self.scrollViewInsetsDefaultValue
            }, completion: { finished in
                weakSelf!.animator.pullToRefresh(weakSelf!, progressDidChange: 0)
        })
    }
    
}

