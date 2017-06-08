//
//  UIView+Extension.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/26.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

extension UIView{

    var x: CGFloat{
        get{
            return frame.origin.x
        }
        set(newValue){
            var tempFram : CGRect = frame
            tempFram.origin.x = newValue
            frame = tempFram
        }
    }
    
    var y: CGFloat{
        get{
            return frame.origin.y
        }
        set(newValue){
            var tempFram : CGRect = frame
            tempFram.origin.y = newValue
            frame = tempFram
        }
    }
    
    var width: CGFloat{
        get{
            return frame.size.width
        }
        set(newValue){
            var tempFram : CGRect = frame
            tempFram.size.width = newValue
            frame = tempFram
        }
    }
    
    var height: CGFloat{
        get{
            return frame.size.height
        }
        set(newValue){
            var tempFram : CGRect = frame
            tempFram.size.height = newValue
            frame = tempFram
        }
    }
    
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y = newValue
            center = tempCenter;
        }
    }

}