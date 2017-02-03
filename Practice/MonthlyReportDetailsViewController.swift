//
//  MonthlyReportDetailsViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/10.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import AVFoundation
class MonthlyReportDetailsViewController: BaseViewController {
    var modelArray = [MonthlyRecordModel]()
    var imgArray = [String]()
    var img = UIImageView()
    var URLString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "月报详情")
        self.addBackButton()
        self.CreatUI()
    }

}
extension MonthlyReportDetailsViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarHidden()
    }
}
private extension MonthlyReportDetailsViewController {
    func CreatUI()  {
        let model = modelArray[0]
        let myscrollview = UIScrollView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        myscrollview.bounces = false
        self.view.addSubview(myscrollview)
        let plan =  MonthlyReportDetailsView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10), title: "工作计划:", content: model.plan)
//        plan.heroID = model.id
        myscrollview.addSubview(plan)
        let summary = MonthlyReportDetailsView.init(frame: CGRect(x: 0, y: YH(plan), width: SCREEN_WIDTH, height: 10), title: "工作总结:", content: model.summary)
        myscrollview.addSubview(summary)
        let MonthlyReport = MonthlyReportDetailsView.init(frame: CGRect(x: 0, y: YH(summary), width: SCREEN_WIDTH, height: 10), title: "备注:", content: model.descn)
        myscrollview.addSubview(MonthlyReport)
        myscrollview.contentSize = CGSize(width: 0, height: YH(MonthlyReport)+0.15*SCREEN_WIDTH)
        let picSpace = SCREEN_WIDTH * 0.25 / 6
        for (idx,obj) in model.Files.enumerated() {
            if obj.ext.isEqual(to: "mp4") {
                //获取网络视频
                URLString = obj.path
                let videoURL = NSURL(string: URLString)!
                let avAsset = AVURLAsset(url: videoURL as URL)
                img = UIImageView(frame: CGRect(x: 0, y: YH(MonthlyReport)+0.2*SCREEN_WIDTH, width: SCREEN_WIDTH, height: SCREEN_WIDTH/2))
                img.contentMode = UIViewContentMode(rawValue: 1)!
                img.isUserInteractionEnabled = true
                img.image = UIImage(named: "tab_home_blue")
//                img.heroID = "PlayVideo"
                myscrollview.addSubview(img)
                let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.clickImage))
                img.addGestureRecognizer(singleTap)
                myscrollview.contentSize = CGSize(width: 0, height: YH(img)+20)
                DispatchQueue.global().async {
                    //生成视频截图
                    let generator = AVAssetImageGenerator(asset: avAsset)
                    generator.appliesPreferredTrackTransform = true
                    let time = CMTimeMakeWithSeconds(0.0,600)
                    var actualTime:CMTime = CMTimeMake(0,0)
                    do {
                        let imageRef:CGImage = try generator.copyCGImage(at: time, actualTime: &actualTime)
                        Thread.sleep(forTimeInterval: 2)
                        print("异步任务执行完毕")
                        //在主线程中显示截图
                        DispatchQueue.main.async {
                            let frameImg = UIImage(cgImage: imageRef)
                            self.img.image = frameImg
                        }
                    } catch  {
                        print("视频截图异常")
                    }
                    
                }
            } else {
                let imgBtn = CreateUI.Button("", action: #selector((self.imgClick(btn:))), sender: self, frame: CGRect(x: picSpace+(0.15 * SCREEN_WIDTH + picSpace)*ConversionCGFloat(idx), y: YH(MonthlyReport)+5, width: 0.15 * SCREEN_WIDTH, height: 0.15 * SCREEN_WIDTH), backgroundColor: UIColor.clear, textColor: UIColor.clear)
                imgBtn.tag = idx
                imgBtn.sd_setBackgroundImage(with: URL(string: obj.path), for: .normal, placeholderImage: UIImage(named: "tab_home_blue"))
                myscrollview.addSubview(imgBtn)
                imgArray.append(obj.path)
            }
        }
    }
    
    @objc func clickImage() -> Void {
        let PlayVideo = PlayTheVideo()
        PlayVideo.URLString =  URLString
        self.navigationController?.pushViewController(PlayVideo, animated: true)
    }
    @objc func imgClick(btn:UIButton) -> Void {
        let img = ImageScrollview.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), imgarray: imgArray as NSArray, idx: btn.tag, isURL: true)
        self.view.addSubview(img)
        img.transform = .init(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.2) {
            img.transform = .init(scaleX: 1.0, y: 1.0)
        }
        img.returnBlock = {
            () in
            img.removeFromSuperview()
        }
    }
}
