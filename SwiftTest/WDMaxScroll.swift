//
//  WDMaxScroll.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/27.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol WDScrollViewDelegate {
    @objc optional func maxscrollClickedOnIndex(index:Int)
}

class WDMaxScroll: UIScrollView,UIScrollViewDelegate {
    
    enum ScrollDirection:String {
        case None,Left,Right
    }
    
    var titleArr = [String](){                                 //标题数组
        didSet{
        currentImageLabel.text = titleArr.first
        }
    }
    
    var scrollImageArray = [String]() {                       //图片数组
        didSet{
            currentImageV.kf_setImageWithURL(NSURL(string: scrollImageArray.first!))
            startTimer()
        }
    }
    
    var clickDelegate: WDScrollViewDelegate?                   //点击代理
    
    private var timer:NSTimer?                                 //自动滚动定时器
    
    private var scrollViewWidth:CGFloat?                       //滚动视图的宽度
    
    private var scrollViewHeight:CGFloat?                      //滚动视图的高度
    
    private var currentImageV = UIImageView()                  //当前显示在屏幕上的图片
    
    private var otherImageV = UIImageView()                    //另外一个显示在屏幕上的图片
    
    private var currentIndex:Int = 0                           //显示在屏幕上的那张图片在图片数组中位置
    
    private var nextIndex:Int?                                 //下一张要显示在图片的数组中位置
    
    private var otherImageLabel = UILabel()                    //当前显示在屏幕上的标题
    
    private var currentImageLabel = UILabel()                  //另外一个显示在屏幕上的标题
    
    private var pageControlDots = [UIView]()                   //pageControl点数组
    
    private var direction:ScrollDirection = .None{             //滚动的方向
        didSet{
            obesvreDirection(direction, oldDirection: oldValue)
        }
    }

    
    
    //MARK: - 初始化
    init(scrollViewFrame frame:CGRect,delegate del:WDScrollViewDelegate?=nil){
        
        super.init(frame: frame)
        
        scrollViewWidth = frame.size.width
        scrollViewHeight = frame.size.height
        delegate = self
        clickDelegate = del
        contentSize = CGSizeMake(scrollViewWidth!*3, scrollViewHeight!)
        contentOffset = CGPointMake(scrollViewWidth!, 0)
        pagingEnabled = true
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        addTwoImageViewToScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        
    }
    
    
    //创造两个imagev
    func addTwoImageViewToScrollView(){
        
        otherImageV = UIImageView(frame: CGRectMake(scrollViewWidth!, 0, scrollViewWidth!, scrollViewHeight!) )
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(currentBtnClicked))
        currentImageV.addGestureRecognizer(tap1)
        self.addSubview(otherImageV)
        
        let otherLabelBG = createViewWithLabel()
        otherImageV.addSubview(otherLabelBG)
        
        otherImageLabel = createLabelInImage()
        otherLabelBG.addSubview(otherImageLabel)
        
        currentImageV = UIImageView(frame: CGRectMake(scrollViewWidth!, 0, scrollViewWidth!, scrollViewHeight!))
        currentImageV.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(currentBtnClicked))
        currentImageV.addGestureRecognizer(tap)
        self.addSubview(currentImageV)
        
        let currentLabelBG = createViewWithLabel()
        currentImageV.addSubview(currentLabelBG)
        
        currentImageLabel = createLabelInImage()
        currentLabelBG.addSubview(currentImageLabel)
    }
    
    func createViewWithLabel() -> UIView{
        let labelHeight = scrollViewHeight! * 1/8;
        let view = UIView(frame: CGRectMake(0, scrollViewHeight! - labelHeight, scrollViewWidth!, labelHeight));
        view.backgroundColor = WDColor(173, 171, 159, 1.0)
        return  view;
    }
    
    func createLabelInImage() ->UILabel{
        let labelHeight = scrollViewHeight! * 1/8;
        let label = UILabel(frame: CGRectMake(10, 0, scrollViewWidth!, labelHeight));
        label.font = UIFont.systemFontOfSize(15);
        return  label;
    }
    
    func startTimer(){
        if (scrollImageArray.count <= 1) {return}
        timer = NSTimer(timeInterval: 3, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func nextPage(){
        self.setContentOffset(CGPointMake(scrollViewWidth! * 2 , 0), animated:true)
    }
    
    func pauseScroll(){
        direction = .None
        
        if contentOffset.x/scrollViewWidth! == 1 {
            return
        }
        
        currentIndex = nextIndex!
        currentImageV.image = otherImageV.image
        currentImageLabel.text = otherImageLabel.text
        contentOffset = CGPointMake(scrollViewWidth!, 0)
        
        changePageControlDot(currentIndex)
    }
    
    
    //MARK: -ScrollDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        direction = contentOffset.x > scrollViewWidth ? .Left :.Right;
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pauseScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        pauseScroll()
    }
    
    //MARK: - 图片点击代理执行
    func currentBtnClicked(){
        if clickDelegate != nil {
            clickDelegate?.maxscrollClickedOnIndex!(currentIndex)
        }
    }
    
    //MARK: - 滚动方向Direction监视器
    func obesvreDirection(direction:ScrollDirection,oldDirection:ScrollDirection){
        if direction == oldDirection{return}
        switch direction {
        case .Left:
            otherImageV.frame = CGRectMake(scrollViewWidth! * 2, 0, scrollViewWidth!, scrollViewHeight!)
            nextIndex = currentIndex+1
            if nextIndex >= scrollImageArray.count {
                nextIndex = 0;
            }
        case .Right:
            otherImageV.frame = CGRectMake(0, 0, scrollViewWidth!, scrollViewHeight!)
            nextIndex = currentIndex-1
            if nextIndex < 0 {
                nextIndex = scrollImageArray.count - 1
            };
        default: break
        }
        //设置 标题
        if nextIndex >= titleArr.count || nextIndex < 0{return}
        otherImageLabel.text = titleArr[nextIndex!];
        otherImageV.kf_setImageWithURL(NSURL(string: scrollImageArray[nextIndex!] ))

    }
    
    
    //MARK: - pageControl
    override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
        let pageControl_width:CGFloat = 6.0
        let pageControl_margin:CGFloat = 8.0
        let pageControl_x = (pageControl_width+pageControl_margin)*CGFloat(scrollImageArray.count-1)+pageControl_width
        for i in 0..<scrollImageArray.count{
            let dot = UIView(frame: CGRectMake(kWidth-pageControl_x+(pageControl_width+pageControl_margin)*CGFloat(i)-10.0, 0, pageControl_width, pageControl_width))
            dot.center = CGPointMake(dot.x+dot.width/2, scrollViewHeight!/8/2+scrollViewHeight!/8*7)
            dot.layer.borderColor = UIColor.grayColor().CGColor
            dot.layer.borderWidth = 1.0
            dot.tag = 150+i
            pageControlDots.append(dot)
            if self.superview != nil {
                self.superview!.addSubview(dot)
            }
            if i==0 {
                dot.transform = CGAffineTransformMakeScale(7/6, 7/6)
                dot.backgroundColor = UIColor.grayColor()
            }
        }
    }
    //修改dot样式
    func changePageControlDot(currentIndex:Int){
        for dot in pageControlDots{
            if dot.tag-150 == currentIndex {
                dot.transform = CGAffineTransformMakeScale(7/6, 7/6)
                dot.backgroundColor = UIColor.grayColor()
            }else{
                dot.transform = CGAffineTransformIdentity
                dot.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
}
