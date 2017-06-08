//
//  WDRefreshFooterView.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/6.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

private var KVOContext = "WDRefreshFooterContext"
private let ContentOffsetKeyPath = "contentOffset"

public class WDRefreshFooterView: UIView {
        
    private var scrollViewBouncesDefaultValue: Bool = false
    private var scrollViewInsetsDefaultValue: UIEdgeInsets = UIEdgeInsetsZero
    
    private var animator:WDRefreshViewDelegate
    private var animatorView:UIView?
    private var action: () ->Void = {}
    
    private var previousOffset: CGFloat = 0
    
    var isCouldLoad:Bool = true{
        didSet{
            if isCouldLoad != oldValue {
                if !isCouldLoad {
                    stopAnimating()
                }
            }
        }
    }
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
        self.animatorView = animator.animatorView
        addSubview(animator.animatorView)
    }
    
    convenience init(action :() -> Void, frame: CGRect, animator: WDRefreshViewDelegate, subview: UIView) {
        self.init(frame: frame, animator: animator)
        self.action = action;
        self.animatorView = subview
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
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeNoMoreState), name: NOMOREDATANOTIFICATION, object: nil)
            scrollViewBouncesDefaultValue = scrollView.bounces
            scrollViewInsetsDefaultValue = scrollView.contentInset
        }
    }
    
    func changeNoMoreState(){
        isCouldLoad = true
    }
    
    //MARK: - KVO监测contentoffset
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (context == &KVOContext) {

            if let scrollView = superview as? UIScrollView  where object as? NSObject == scrollView {
                if scrollView.contentOffset.y+scrollView.bounds.size.height >= scrollView.contentSize.height {
                    animatorView?.frame = CGRectMake(0, scrollView.contentSize.height, (animatorView?.frame.size.width)!, (animatorView?.frame.size.height)!)
                    addSubview(animatorView!)
                }

                if !isCouldLoad {
                    animator.pullToRefresh(self, progressDidChange: 0)
                    animator.pullToRefresh(self, stateDidChange: .noMoreData)
                    return
                }
                
                if keyPath == ContentOffsetKeyPath {
                    let offsetWithoutInsets = previousOffset-scrollView.contentSize.height
                    if (offsetWithoutInsets > self.frame.size.height) {
                        if (scrollView.dragging == false && loading == false) {
                            loading = true
                        } else if (loading) {
                            animator.pullToRefresh(self, stateDidChange: .loading)
                        } else {
                            animator.pullToRefresh(self, stateDidChange: .releaseToRefresh)
                            animator.pullToRefresh(self, progressDidChange: offsetWithoutInsets / self.frame.size.height)
                        }
                    } else if (loading) {
                        animator.pullToRefresh(self, stateDidChange: .loading)
                    } else if (offsetWithoutInsets > 0) {
                        animator.pullToRefresh(self, stateDidChange: .pulling)
                        animator.pullToRefresh(self, progressDidChange: offsetWithoutInsets / self.frame.size.height)
                    }
                    previousOffset = scrollView.contentOffset.y+scrollView.bounds.size.height
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
        insets.bottom += self.frame.size.height
        
        scrollView.contentOffset.y = previousOffset - scrollView.bounds.size.height
        scrollView.bounces = false
        weak var weakSelf = self
        UIView.animateWithDuration(0.3, animations: {
            scrollView.contentInset = insets
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height+insets.bottom-scrollView.bounds.size.height)
        }) { finished in
            weakSelf!.animator.pullToRefreshAnimationDidStart(self)
            weakSelf!.action()
        }
    }
    
    func stopAnimating(){
        animatorView?.removeFromSuperview()
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

