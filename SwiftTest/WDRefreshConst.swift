//
//  WDRefreshConst.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/6.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

//不可配置
public enum WDRefreshState:String {
    case loading
    case pulling
    case releaseToRefresh
    case noMoreData
}

public protocol WDRefreshViewDelegate {
    func pullToRefreshAnimationDidStart(WDRefreshView: UIView)
    func pullToRefreshAnimationDidEnd(WDRefreshView: UIView)
    func pullToRefresh(WDRefreshView: UIView, progressDidChange progress: CGFloat)
    func pullToRefresh(WDRefreshView: UIView, stateDidChange state: WDRefreshState)
}

let NOMOREDATANOTIFICATION = "noMoreDataNotification"

//可配置
let STARTREFRESH = "刷新中..."
let PULLTOREFRESH = "下拉可以刷新"
let RELEASETOREFRESH = "松开立即刷新"
let LABELFONTSIZE_HEADER:CGFloat = 14.0

let STARTLOAD = "加载中..."
let PULLTOLOAD = "上拉加载更多"
let RELEASETOLOAD = "松开立即刷新"
let NOMOREDATA = "到底了~"
let LABELFONTSIZE_FOOTER:CGFloat = 14.0