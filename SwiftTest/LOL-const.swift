//
//  LOL-pch.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/25.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

let kWidth = UIScreen.mainScreen().bounds.size.width
let kHeight = UIScreen.mainScreen().bounds.size.height
let kStatusHeight:CGFloat = 20.0
let kNavigationHeight:CGFloat = 44.0
let kTabbarHeight:CGFloat = 49.0

/// RGBA的颜色设置
func WDColor( r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 背景灰色
func WDGlobalColor() -> UIColor {
    return WDColor(240, 240, 240, 1)
}

/// 红色
func YMGlobalRedColor() -> UIColor {
    return WDColor(245, 80, 83, 1.0)
}

//咨询请求地址
let NewsURLPath = "http://qt.qq.com/static/pages/news/phone/"