//
//  HttpTool.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/26.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON
import Toast_Swift

class HttpTool: NSObject {
    
    enum MethodType:String {
        case Get,Post
    }
    
    //MARK: - 单例
    static let sharedInstance = HttpTool()
 
    //MARK: - 咨询头数据
    func getTitleArr(finished:[NewsTitleModel]->Void ){
        var titles = [NewsTitleModel]()
        baseRequest(.Get, Url: "http://qt.qq.com/static/pages/news/phone/index.js"){responseJSON in
                let dataArr = responseJSON as? [[String:String]]
                for dict in dataArr!{
                    if let model = JSONDeserializer<NewsTitleModel>.deserializeFrom(dict) {
                        titles.append(model)
                    }
                }
                finished(titles)
        }
        
    }
    
    
    //MARK: - 最新 轮播图
    func getNewestScrollData(finished:[NewestScrollImageModel]->Void){
        getSubVCData("13",page: 1, finished: finished,errored: {})
    }
    
    //MARK: - 咨询子内容
    func getSubVCData(subUrl:String,page:NSInteger,finished:[NewestScrollImageModel]->Void,errored:()->()){
        var listArr = [NewestScrollImageModel]()
        baseRequest(.Get, Url: "http://qt.qq.com/static/pages/news/phone/c\(subUrl)_list_\(page).shtml",  errorCallback: { 
                errored()
        }) {responseJSON in
            let dataDict = responseJSON as? [String:AnyObject]
            for dic in (dataDict!["list"] as? [[String:String]])!{
                if let model = JSONDeserializer<NewestScrollImageModel>.deserializeFrom(dic) {
                    listArr.append(model)
                }
            }
            finished(listArr)
        }
    }
    
    
    //MARK: - BaseHttpTool
    func baseRequest(Method:MethodType,Url:String,params:[String: AnyObject]? = nil,errorCallback:(()->Void)? = nil,successCallback:(_:Any)->Void){
        
        weak var weakSelf = self
        Alamofire.request(Method == .Get ? .GET : .POST, NSURL(string: Url)!, parameters: params).responseJSON{response in
            switch response.result{
            case .Success:
                print("-----------\(Method):\(Url)")
                print("-----------\(response.result.value)")
                successCallback(response.result.value)
            case .Failure:
                print("-----------错误报告：\(response.result.error)")
                weakSelf!.showError()
                if errorCallback != nil{
                   errorCallback!()
                }
            }
        }
    }

    
     //MARK: - 网络错误toast
     func showError(){
        let view = UIApplication.sharedApplication().windows.last
        view?.makeToast("网络出错了~", duration: 1.5, position: .Center )
    }
    
    
}





