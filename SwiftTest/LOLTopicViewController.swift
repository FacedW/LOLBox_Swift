//
//  LOLTopicViewController.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/26.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

class LOLTopicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WDScrollViewDelegate{
    var newsTitleModel: NewsTitleModel?
    
    lazy var imgScroll:WDMaxScroll = { [weak self] in 
        let scroll = WDMaxScroll(scrollViewFrame: CGRectMake(0, 0, kWidth, kWidth/2), delegate:self)
        return scroll
    }()
    
    lazy private var scrollUrls = {[String]()}()                                 //轮播视图的url
    
    private var tableV = UITableView()                                           //tableV
    
    lazy private var dataArr = {[NewestScrollImageModel]()}()                    //数据源

    private var pageNum = 1                                                      //页码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        creatUI()
        loadScrollData()
        loadData()
        
        
        weak var weakSelf = self
        tableV.addWDRefreshHeaderWithAnimator(LOLRefreshView(frame:CGRectMake(0,0,view.width,50)), action: {
            weakSelf?.loadData()
        })
        tableV.addWDRefreshFooterWithAction { 
            weakSelf!.loadMoreData()
        }
        
    }
    
    //MARK: - 创建UI
    func creatUI(){
        
        tableV = UITableView(frame: CGRectMake(0, 0, kWidth, kHeight-kStatusHeight-kNavigationHeight-kTabbarHeight), style: .Grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.rowHeight = 80.0
        view.addSubview(tableV)
        
        tableV.registerNib(UINib(nibName: "LOLNewsCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "LOLNewsCell")
        print("++++++++++++++++++++\(NSStringFromClass(object_getClass(LOLNewsCell)))")
        print("+++++++++++++++++++\(LOLNewsCell.self)")
    }
    
    //MARK: - tableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LOLNewsCell", forIndexPath: indexPath) as! LOLNewsCell
        cell.selectionStyle = .None
        cell.model = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if newsTitleModel?.id == "12" {
            return imgScroll
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if newsTitleModel?.id == "12" {
            return kWidth/2
        }else{
            return 0.1
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let str = dataArr[indexPath.row].article_url
        let URLStr = (str?.hasPrefix("http://"))! == true ? str : NewsURLPath+str!
        let webVC = LOLWebViewController()
        webVC.webURLStr = URLStr
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    //MARK: - 数据请求
    func loadNewData(){
        pageNum = 1
        loadData()
    }
    
    func loadMoreData(){
        pageNum += 1
        loadData()
    }
    
    func loadData(){//列表数据
        weak var weakSelf = self
        HttpTool.sharedInstance.getSubVCData("\((newsTitleModel?.id)!)", page: pageNum,
                finished: { arr in
                    if weakSelf!.pageNum == 1 {
                       weakSelf!.dataArr.removeAll()
                    }
                    weakSelf!.dataArr += arr
                    weakSelf?.tableV.stopRefresh()
                    weakSelf?.tableV.stopLoad()
                    weakSelf!.tableV.reloadData()},
                errored: {
                    weakSelf?.tableV.stopRefresh()
                    weakSelf?.tableV.stopLoad()
                    weakSelf?.tableV.noMoreData()
        })
    }
    
    func loadScrollData(){//轮播数据
        weak var weakSelf = self
        var scrollImages = [String]()
        var scrollTitles = [String]()
        HttpTool.sharedInstance.getNewestScrollData(){ dataArr in
            for model in dataArr{
                scrollImages.append(model.image_url_big!)
                scrollTitles.append(model.title!)
                weakSelf?.scrollUrls.append(model.article_url!)
            }
            weakSelf!.imgScroll.scrollImageArray = scrollImages
            weakSelf!.imgScroll.titleArr = scrollTitles
        }
    }
    
    //MARK: - WDScrollViewDelegate
    func maxscrollClickedOnIndex(index: Int) {
        let str = scrollUrls[index]
        let URLStr = str.hasPrefix("http://") == true ? str : NewsURLPath+str
        let webVC = LOLWebViewController()
        webVC.webURLStr = URLStr
        navigationController?.pushViewController(webVC, animated: true)
    }

}
