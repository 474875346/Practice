//
//  HttpRequestTool.swift
//  Swift-Request
//
//  Created by 新龙科技 on 2016/12/9.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//创建请求类枚举
enum RequestType: Int {
    case GET
    case POST
}
//创建一个闭包(注:oc中block)
typealias sendVlesClosure = (AnyObject?, NSError?)->Void
typealias uploadClosure = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void


class HttpRequestTool: NSObject {
    /*
     *单例类
     */
    static var sharedInstance : HttpRequestTool = {
        let instance  = HttpRequestTool()
        return instance
    }()
}
extension HttpRequestTool {
    /*
     *GET请求和POST请求封装
     *URL：请求网址
     *TYPE：请求类型
     *Parameters：请求参数（字典类型）
     *Successed：成功请求回调
     *Failed：失败请求回调
     */
    func HttpRequestJSONDataWithUrl(url: String , type:RequestType , parameters: [String:String], successed:@escaping (_ responseObject: JSON? ) -> (), failed: @escaping (_ error: NSError?) -> ()) {
        //请求类型
        let HTTPType:HTTPMethod = type == .GET ? .get : .post
        //请求网址
        let URLString = "\(BaseURL)\(url)"
        //请求网址和参数的输出
        print("URL：\(URLString)\nparameters:\(parameters)")
        //发送请求
        Alamofire.request(URLString, method: HTTPType ,parameters:parameters).validate().responseJSON(completionHandler: { DataResponse in
            if DataResponse.result.isSuccess {
                let json = JSON(DataResponse.result.value as Any)
                successed(json)
            }else {
                failed(DataResponse.result.error as NSError?)
            }
        })
    }
    /*
     *单张上传图片请求
     *URL：请求网址
     *image：上传图片
     *Parameters：请求参数（字典类型）
     *Successed：成功请求回调
     *Failed：失败请求回调
     */
    func HttpRequestUpload(url:String , parameters:[String:String] , image:UIImage , successed:@escaping(_ resposeObject:AnyObject?)->() , failed:@escaping(_ error:NSError?)->()) {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let imageData = UIImagePNGRepresentation(image)!
                multipartFormData.append(imageData, withName: "file", fileName: "11.png", mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        },to: url,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.isSuccess {
                        successed(response.data as AnyObject?)
                    }else {
                        failed(response.result.error as NSError?)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        )
    }
}

