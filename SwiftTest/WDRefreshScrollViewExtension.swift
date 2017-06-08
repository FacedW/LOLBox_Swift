//
//  WDRefreshScrollViewExtension.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/5.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

private let RefreshHeaderTag = 888
private let RefreshFooterTag = 889
private let RefreshDefaultHeight: CGFloat = 50.0

extension UIScrollView {

    // MARK: - WDRefreshHeader
    
    public var WD_RefreshHeader: WDRefreshHeaderView? {
        get {
            let pullToRefreshView = viewWithTag(RefreshHeaderTag)
            return pullToRefreshView as? WDRefreshHeaderView
        }
    }
    
    // MARK:添加默认RefreshHeader
    public func addWDRefreshHeaderWithAction(action:() -> Void) {
        let refreshView = WDRefreshHeaderView(action: action, frame: CGRect(x: 0, y: -RefreshDefaultHeight, width: self.frame.size.width, height: RefreshDefaultHeight))
        refreshView.tag = RefreshHeaderTag
        addSubview(refreshView)
    }
    
    // MARK:添加自定义的animator和header
    public func addWDRefreshHeaderWithAnimator(animator: WDRefreshViewDelegate, withSubview subview: UIView, action:() -> Void) {
        let height = subview.frame.height
        let refreshView = WDRefreshHeaderView(action: action, frame: CGRect(x: 0, y: -height, width: self.frame.size.width, height: height), animator: animator, subview: subview)
        refreshView.tag = RefreshHeaderTag
        addSubview(refreshView)
    }
    
    // MARK:添加自定义header
    public func addWDRefreshHeaderWithAnimator <T: UIView where T:WDRefreshViewDelegate>( animator: T ,action:() -> ()) {
        let height = animator.frame.height
        let refreshView = WDRefreshHeaderView(action: action, frame: CGRect(x: 0, y: -height, width: self.frame.size.width, height: height), animator: animator, subview: animator)
        refreshView.tag = RefreshHeaderTag
        addSubview(refreshView)
    }
    
    // MARK:刷新和结束刷新
    public func startRefresh() {
        WD_RefreshHeader?.loading = true
    }

    public func stopRefresh() {
        WD_RefreshHeader?.loading = false
    }

    
    
    // MARK: - WDRefreshFooter
    
    
    public var WD_RefreshFooter: WDRefreshFooterView? {
        get {
            let pullToRefreshView = viewWithTag(RefreshFooterTag)
            return pullToRefreshView as? WDRefreshFooterView
        }
    }
    
    // MARK:添加默认RefreshFooter
    public func addWDRefreshFooterWithAction(action:() -> Void) {
        let refreshView = WDRefreshFooterView(action: action, frame: CGRect(x: 0, y: 0, width: frame.size.width, height: RefreshDefaultHeight))
        refreshView.tag = RefreshFooterTag
        addSubview(refreshView)
    }
    
    // MARK:添加自定义的animator和footer
    public func addWDRefreshFooterWithAnimator(animator: WDRefreshViewDelegate, withSubview subview: UIView ,action:() -> Void) {
        let height = subview.frame.height
        let refreshView = WDRefreshFooterView(action: action, frame: CGRect(x: 0, y: 0, width: frame.size.width, height: height), animator: animator, subview: subview)
        refreshView.tag = RefreshFooterTag
        addSubview(refreshView)
    }
    
    // MARK:添加自定义footer
    public func addWDRefreshFooterWithAnimator <T: UIView where T:WDRefreshViewDelegate>(animator: T ,action:() -> ()) {
        let height = animator.frame.height
        let refreshView = WDRefreshFooterView(action: action, frame: CGRect(x: 0, y: 0, width: frame.size.width, height: height), animator: animator, subview: animator)
        refreshView.tag = RefreshFooterTag
        addSubview(refreshView)
    }
    
    // MARK:刷新和结束加载
    public func startLoad() {
        WD_RefreshFooter?.loading = true
    }
    
    public func stopLoad() {
        WD_RefreshFooter?.loading = false
    }

    public func noMoreData(){
        if WD_RefreshFooter != nil {
            WD_RefreshFooter!.isCouldLoad = false
        }
    }
    
}
