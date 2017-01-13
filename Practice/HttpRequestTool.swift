//
//  HttpRequestTool.swift
//  Swift-Request
//
//  Created by 新龙科技 on 2016/12/9.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
//创建请求类枚举
enum RequestType: Int {
    case GET
    case POST
}
//创建一个闭包(注:oc中block)
typealias sendVlesClosure = (AnyObject?, NSError?)->Void
typealias uploadClosure = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void
let activityIndi​​catorView:NVActivityIndicatorView? = NVActivityIndicatorView(frame: CGRect(x: SCREEN_WIDTH/2-25, y: SCREEN_HEIGHT/2, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: Int(arc4random())%27), color: UIColor.red, padding: 1.0)

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
    
    //MARK:定义一个结构体，存储认证相关信息
    struct IdentityAndTrust {
        var identityRef:SecIdentity
        var trust:SecTrust
        var certArray:AnyObject
    }
    /*
     *MARK:-GET请求和POST请求封装
     *URL：请求网址
     *TYPE：请求类型
     *Parameters：请求参数（字典类型）
     *Successed：成功请求回调
     *Failed：失败请求回调
     */
    func HttpRequestJSONDataWithUrl(url: String , type:RequestType , parameters: [String:String],SafetyCertification:Bool,successed:@escaping (_ responseObject: AnyObject? ) -> (), failed: @escaping (_ error: NSError?) -> ()) {
        if SafetyCertification {
            self.SafetyCertification()
        }
        activityIndi​​catorView?.startAnimating()
        //请求类型
        let HTTPType:HTTPMethod = type == .GET ? .get : .post
        //请求网址
        let URLString = "\(BaseURL)\(url)"
        //请求网址和参数的输出
        print("URL：\(URLString)\nparameters:\(parameters)")
        //发送请求
        Alamofire.request(URLString, method: HTTPType ,parameters:parameters).validate().responseJSON(completionHandler: { DataResponse in
            if DataResponse.result.isSuccess {
                print(DataResponse.result.value!)
                successed(DataResponse.result.value as AnyObject?)
            }else {
                print(DataResponse.result.error as Any)
                failed(DataResponse.result.error as NSError?)
            }
            activityIndi​​catorView?.stopAnimating()
        })
    }
    func SafetyCertification() -> Void {
        //认证相关设置
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器证书
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust {
                print("服务端证书认证！")
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
                let cerPath = Bundle.main.path(forResource: "tomcat", ofType: "cer")!
                let cerUrl = URL(fileURLWithPath:cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
                
                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential,
                            URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    
                } else {
                    return (.cancelAuthenticationChallenge, nil)
                }
            }
                //认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:IdentityAndTrust = self.extractIdentity();
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            }
                // 其它情况（不接受认证）
            else {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    
    //获取客户端证书相关信息
    func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "client", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "123456"] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!
                print("\(identityPointer)  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                print("\(trustPointer)  :::: \(trustRef)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                    trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
    /*
     *MARK:单张上传图片请求
     *URL：请求网址
     *image：上传图片
     *Parameters：请求参数（字典类型）
     *Successed：成功请求回调
     *Failed：失败请求回调
     */
    func HttpRequestUpload(url:String , parameters:[String:String] , image:UIImage , successed:@escaping(_ resposeObject:AnyObject?)->() , failed:@escaping(_ error:NSError?)->()) {
        activityIndi​​catorView?.startAnimating()
        //请求网址
        let URLString = "\(BaseURL)\(url)"
        //请求网址和参数的输出
        print("URL：\(URLString)\nparameters:\(parameters)")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let imageData = UIImageJPEGRepresentation(image, 0.5)!
                let timeInterval = NSDate().timeIntervalSince1970 * 1000
                multipartFormData.append(imageData, withName: "file", fileName: "\(timeInterval).jpg", mimeType: "jpg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        },to: URLString,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.isSuccess {
                        print(response.result.value as Any)
                        successed(response.result.value as AnyObject?)
                    }else {
                        failed(response.result.error as NSError?)
                    }
                    activityIndi​​catorView?.stopAnimating()
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        )
    }
    /**
     MARK:视频上传
     - parameter url:        请求网址
     - parameter parameters: 请求参数
     - parameter dataArray:  二进制数组
     - parameter type:       上传类型
     - parameter successed:  成功回调
     - parameter failed:     失败回调
     */
    func HttpRequestVideoUpload(url:String , parameters:[String:String] , dataArray:NSMutableArray,type:NSMutableArray , successed:@escaping(_ resposeObject:AnyObject?)->() , failed:@escaping(_ error:NSError?)->()) {
        activityIndi​​catorView?.startAnimating()
        //请求网址
        let URLString = "\(BaseURL)\(url)"
        //请求网址和参数的输出
        print("URL：\(URLString)\nparameters:\(parameters)")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                dataArray.enumerateObjects({ (obj, idx, stop) in
                    let data = obj as! Data
                    let timeInterval = NSDate().timeIntervalSince1970 * 1000
                    let mimetype = type[idx] as! String
                    let name = "\(timeInterval)\(idx)"
                    let filename = "\(name)\(idx+1).\(mimetype)"
                    multipartFormData.append(data, withName: name, fileName: filename, mimeType: mimetype)
                })
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        },to: URLString,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.isSuccess {
                        print(response.result.value as Any)
                        successed(response.result.value as AnyObject?)
                    }else {
                        failed(response.result.error as NSError?)
                    }
                    activityIndi​​catorView?.stopAnimating()
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        )
        
    }
}
