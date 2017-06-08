//
//  LOLWebViewController.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/2.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit
import WebKit

class LOLWebViewController: UIViewController,WKNavigationDelegate {
    
    var webURLStr:String?                    //web链接

    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
    }

    func creatUI(){
        title = "资讯详情"
        view.backgroundColor = UIColor.whiteColor()
        
        if webURLStr==nil {return}
        let config = WKWebViewConfiguration()
        let webV = WKWebView(frame: view.bounds, configuration: config)
        let request = NSURLRequest(URL: NSURL(string: webURLStr!)!)
        webV.navigationDelegate = self
        webV.loadRequest(request)
        view.addSubview(webV)
    }
}
