//
//  LOLNewsViewController.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/25.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit
import Alamofire

class LOLNewsViewController: UIViewController,UIScrollViewDelegate {
    
    private lazy var titleArr:[NewsTitleModel] = {[]}()              // 标签数据
    private let titleV_H:CGFloat = 44                                // 标签高度
    private let Spacing:CGFloat = (kWidth - 50 - (4*40))/4           // title之间的间距
    
    private var topScroll:UIScrollView?                               // 顶部滚动视图
    private var viewInTopScrollView:UIView?                           // 指示条
    private var selectedButton:UIButton?                              // 当前选中的按钮
    private var contentView:UIScrollView?                             // 底层滚动视图
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        loadTitles()
    }

// MARK: - 加载页面布局数据
    private func loadTitles(){
        weak var weakSelf = self
        HttpTool.sharedInstance.getTitleArr{ dataArr in
            for model in dataArr{
                let vc = LOLTopicViewController()
                vc.newsTitleModel = model
                weakSelf?.addChildViewController(vc)
            }
            weakSelf!.titleArr = dataArr
            weakSelf!.setupTitlesView()
            weakSelf!.setupContentView()
        }
    }

    
// MARK: - 顶部标签栏
    func setupTitlesView() {
        //标签背景
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 0, width: kWidth, height: titleV_H)
        self.navigationItem.titleView = bgView
        
        let contentSizeWidth = CGFloat(titleArr.count)*(Spacing+40)
        
        topScroll = UIScrollView(frame: CGRectMake(0,8,kWidth-50,44))
        topScroll!.showsVerticalScrollIndicator = false
        topScroll!.showsHorizontalScrollIndicator = false
        topScroll!.contentSize = CGSizeMake(contentSizeWidth, titleV_H)
        topScroll!.alwaysBounceVertical = false
        topScroll!.alwaysBounceHorizontal = true
        bgView.addSubview(topScroll!)
        
        // 选择按钮
        let arrowButton = UIButton()
        arrowButton.frame = CGRect(x: CGRectGetMaxX(topScroll!.frame), y: 0, width: 34, height: titleV_H)
        arrowButton.setImage(UIImage(named: "list_news_top_arrow_normal"), forState: .Normal)
        arrowButton.setImage(UIImage(named: "list_news_top_arrow_pressed"), forState: .Highlighted)
        arrowButton.addTarget(self, action: #selector(arrowButtonClick), forControlEvents: .TouchUpInside)
        bgView.addSubview(arrowButton)
        
        ////在 topScroll 中添加同一个UIView 解决直接添加 UIButton,topScrollView 不能拖动的问题
        viewInTopScrollView = UIView(frame:CGRectMake(0,0,contentSizeWidth,28))
        topScroll!.addSubview(viewInTopScrollView!)
        
        //内部子标签
        let count = titleArr.count
        let width = CGFloat(40.0)
        let height = viewInTopScrollView!.height
        
        for index in 0..<count {
            let button = UIButton()
            button.frame = CGRectMake(CGFloat(index) * (width+Spacing)+Spacing/2, 0, width, height)
            button.tag = index+100
            let model = titleArr[index]
            button.titleLabel!.font = UIFont.systemFontOfSize(17)
            button.setTitle(model.name, forState: .Normal)
            button.setTitleColor(WDColor(232, 184, 114, 1), forState: .Selected)
            button.setTitleColor(WDGlobalColor(), forState: .Disabled)
            button.addTarget(self, action: #selector(titlesClick), forControlEvents: .TouchUpInside)
            viewInTopScrollView!.addSubview(button)
            //默认点击了第一个按钮
            if index == 0 {
                button.selected = true
                selectedButton = button
                selectedButton!.titleLabel?.font = UIFont.systemFontOfSize(19)
            }
        }

    }
    
//MARK: - 底部的scrollview
    func setupContentView() {
        automaticallyAdjustsScrollViewInsets = false
        
        let contentView = UIScrollView()
        contentView.frame = view.bounds
        contentView.delegate = self
        contentView.contentSize = CGSize(width: contentView.width * CGFloat(childViewControllers.count), height: 0)
        contentView.pagingEnabled = true
        view.insertSubview(contentView, atIndex: 0)
        self.contentView = contentView
        //添加第一个控制器的view
        addLOLSubView()
    }
    
    
// MARK: - 箭头按钮点击
    func arrowButtonClick(button: UIButton) {
        if selectedButton!.tag+1-100 == childViewControllers.count{return}
        
        let nextBtn = viewInTopScrollView?.viewWithTag(selectedButton!.tag+1) as! UIButton
        titlesClick(nextBtn)
        
        if selectedButton!.tag+1-100 <= 3 || selectedButton!.tag+1-100 > childViewControllers.count-1 {return}
        topScroll?.contentOffset = CGPointMake(CGFloat(selectedButton!.tag-100)*(40.0+Spacing) - (kWidth-40.0-Spacing)/2, 0)
    }
    
    
// MARK: - 标签上的按钮点击
    func titlesClick(button: UIButton) {
        // 修改按钮状态
        selectedButton!.selected = false
        selectedButton!.titleLabel?.font = UIFont.systemFontOfSize(17)
        button.selected = true
        selectedButton = button
        selectedButton!.titleLabel?.font = UIFont.systemFontOfSize(19)

        //滚动,切换子控制器
        var offset = contentView!.contentOffset
        offset.x = CGFloat(button.tag - 100) * contentView!.width
        contentView!.setContentOffset(offset, animated: false)
        
        addLOLSubView()
    }
    
    
// MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        addLOLSubView()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let button = viewInTopScrollView!.viewWithTag(index+100) as! UIButton
        titlesClick(button)
    }
    
    // 添加控制器视图
    func addLOLSubView(){
        let index = Int(contentView!.contentOffset.x / contentView!.width)
        let vc = childViewControllers[index]
        vc.view.frame = CGRectMake(contentView!.contentOffset.x, 0, kWidth, contentView!.height)
        contentView!.addSubview(vc.view)
    }
}
