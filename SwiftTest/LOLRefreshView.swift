//
//  LOLRefreshView.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/6.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

class LOLRefreshView: UIView,WDRefreshViewDelegate {
    lazy private var imageV:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"common_loading_anne_0")
        imageView.animationImages = [UIImage(named:"common_loading_anne_0")!,UIImage(named:"common_loading_anne_1")!]
        imageView.animationDuration = 0.3
        imageView.animationRepeatCount = 0
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
    
    }
    
    func creatUI(){
        imageV.frame = CGRectMake(0, 0, 60, 40)
        imageV.center = center
        addSubview(imageV)
    }
    
    func pullToRefreshAnimationDidStart(WDRefreshView: UIView){
        
    }
    func pullToRefreshAnimationDidEnd(WDRefreshView: UIView){
    
    }
    func pullToRefresh(WDRefreshView: UIView, progressDidChange progress: CGFloat){
    
    }
    func pullToRefresh(WDRefreshView: UIView, stateDidChange state: WDRefreshState){
    
        if state == .loading {
            imageV.startAnimating()
        }else{
            imageV.stopAnimating()
        }
    }
}
