//
//  MonthlyReportViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import TZImagePickerController
class MonthlyReportViewController: BaseViewController,TZImagePickerControllerDelegate {
    var Videoimg : UIImageView?
    let buttonArray = NSMutableArray()
    let imageArray = NSMutableArray()
    var ImgDataArray = [Any]()
    var ImgTypeArray = [Any]()
    var VideoTypeArray = [Any]()
    var VideoDataArray = [Any]()
    var isVideoCompression = false
    var planTextView : UITextView?
    var summaryTextView : UITextView?
    var MonthlyReportTextView : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.view.heroID = "1"
        self.addNavBackImg()
        self.addNavTitle(Title: "月报")
        self.addBackButton()
        self.CreatUI()
    }
}
extension MonthlyReportViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarHidden()
    }
}
private extension MonthlyReportViewController {
    func CreatUI() -> Void {
        let myscrollview = UIScrollView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-104))
        myscrollview.bounces = false
        self.view.addSubview(myscrollview)
        let plan = TextViewAndLine.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 101), title: "工作计划:", planceholder: "请输入工作计划")
        planTextView = plan.contTextView
        myscrollview.addSubview(plan)
        let summary = TextViewAndLine.init(frame: CGRect(x: 0, y: YH(plan), width: SCREEN_WIDTH, height: 101), title: "工作总结:", planceholder: "请输入工作总结")
        summaryTextView = summary.contTextView
        myscrollview.addSubview(summary)
        let MonthlyReport = TextViewAndLine.init(frame: CGRect(x: 0, y: YH(summary), width: SCREEN_WIDTH, height: 101), title: "备       注:", planceholder: "请输入备注")
        MonthlyReportTextView = MonthlyReport.contTextView
        myscrollview.addSubview(MonthlyReport)
        let Video = CreateUI.Button("视频", action: #selector((self.Viedobtn)), sender: self, frame: CGRect(x: 20, y: YH(MonthlyReport)+20, width: 0.25 * SCREEN_WIDTH, height: 0.25 * SCREEN_WIDTH), backgroundColor: RGBA(29, g: 138, b: 245, a: 1.0), textColor: UIColor.white)
        LRViewBorderRadius(Video, Radius:  0.25 * SCREEN_WIDTH/2, Width: 0, Color: UIColor.clear)
        myscrollview.addSubview(Video)
        Videoimg = UIImageView(frame: CGRect(x: XW(Video)+20, y: YH(MonthlyReport)+20, width: 0.25 * SCREEN_WIDTH, height: 0.25 * SCREEN_WIDTH))
        myscrollview.addSubview(Videoimg!)
        let picSpace = SCREEN_WIDTH * 0.25 / 6
        let addPicture = CreateUI.Button("", action: #selector((self.addPicture)), sender: self, frame: CGRect(x: picSpace, y: YH(Video)+20, width: 0.15 * SCREEN_WIDTH, height: 0.15 * SCREEN_WIDTH), backgroundColor: UIColor.clear, textColor: UIColor.clear)
        addPicture.setBackgroundImage(UIImage(named: "addPic"), for: .normal)
        myscrollview.addSubview(addPicture)
        let deletePictureButton = CreateUI.Button("", action: #selector((self.deletePicture)), sender: self, frame: CGRect(x:XW(addPicture)+picSpace, y: YH(Video)+20, width: 0.15 * SCREEN_WIDTH, height: 0.15 * SCREEN_WIDTH), backgroundColor: UIColor.clear, textColor: UIColor.clear)
        deletePictureButton.setBackgroundImage(UIImage(named: "deletePic"), for: .normal)
        myscrollview.addSubview(deletePictureButton)
        for  i in 0..<5 {
            let Button = CreateUI.Button("", action: #selector((self.showImage(_:))), sender: self, frame: CGRect(x:picSpace+(0.15 * SCREEN_WIDTH + picSpace)*ConversionCGFloat(i), y: YH(deletePictureButton)+10, width: 0.15 * SCREEN_WIDTH, height: 0.15 * SCREEN_WIDTH), backgroundColor: UIColor.clear, textColor: UIColor.clear)
            Button.tag = i
            Button.isHidden = true
            myscrollview.addSubview(Button)
            buttonArray.add(Button)
        }
        myscrollview.contentSize = CGSize(width: 0, height: YH(deletePictureButton)+0.15 * SCREEN_WIDTH)
        let submitButton = CreateUI.Button("提交", action: #selector((self.submit)), sender: self, frame: CGRect(x: 0, y: SCREEN_HEIGHT-40, width: SCREEN_WIDTH, height: 40), backgroundColor: RGBA(76, g: 176, b: 253, a: 1.0), textColor: UIColor.white)
        self.view.addSubview(submitButton)
    }
    //MARK:提交数据
    @objc func submit() ->Void {
        print(VideoDataArray.count)
        if isVideoCompression == true {
            if VideoDataArray.count == 0 {
                self.WaringTost(Title: "", Body: "视频还没压缩完成")
                return
            }
        }
        let DataArray = NSMutableArray()
        let mimeTypeArray = NSMutableArray()
        DataArray.addObjects(from: ImgDataArray)
        DataArray.addObjects(from: VideoDataArray)
        mimeTypeArray.addObjects(from: ImgTypeArray)
        mimeTypeArray.addObjects(from: VideoTypeArray)
        HttpRequestTool.sharedInstance.HttpRequestVideoUpload(url:  Student_reported, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"summary":(summaryTextView?.text)!,"plan":(planTextView?.text)!,"descn":(MonthlyReportTextView?.text)!], dataArray: DataArray, type: mimeTypeArray, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "月报提交成功")
                //                self.dismiss(animated: true, completion: nil)
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title:"", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
    //MARK:点击图片放大
    @objc func showImage(_ btn:UIButton) -> Void {
        let img = ImageScrollview.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), imgarray: imageArray, idx: btn.tag, isURL: false)
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
    //MARK:删除图片
    @objc func deletePicture() -> Void {
        imageArray.removeAllObjects()
        ImgDataArray.removeAll()
        ImgTypeArray.removeAll()
        buttonArray.enumerateObjects(using: { (obj, idx, stop) in
            let button = obj as! UIButton
            button.setBackgroundImage(UIImage(named: ""), for: .normal)
            button.isHidden = true
        })
    }
    //MARK:添加图片
    @objc func addPicture() -> Void {
        let addPictureVC = TZImagePickerController.init(maxImagesCount: 5, delegate: self)
        addPictureVC?.didFinishPickingPhotosHandle = {
            (photos,assets,isSelectOriginalPhoto) in
            for image in photos! {
                if self.imageArray.count<5 {
                    self.imageArray.add(image)
                    let imgdata = UIImageJPEGRepresentation(image, 0.5)
                    self.ImgDataArray.append(imgdata as Any)
                    self.ImgTypeArray.append("jpg")
                }
            }
            self.imageArray.enumerateObjects({ (obj, i, stop) in
                let button = self.buttonArray[i] as! UIButton
                let img = self.imageArray[i] as! UIImage
                button.setBackgroundImage(img, for: .normal)
                button.isHidden = false
            })
        }
        self.present(addPictureVC!, animated: true, completion: nil)
    }
    //MARK:视频点击方法
    @objc func Viedobtn() -> Void {
        VideoDataArray.removeAll()
        VideoTypeArray.removeAll()
        isVideoCompression = false
        let chooseViedo = UIAlertController(title: "", message: "选择视频方式!", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let Recordvideo = UIAlertAction(title: "录制视频", style: .default) { (UIAlertAction) in
            self.present(VideoRecordingViewController(), animated: true, completion: nil)
        }
        let Choosethevideo = UIAlertAction(title: "选择视频", style: .default) { (UIAlertAction) in
            self.Choosethevideo()
        }
        chooseViedo.addAction(cancel)
        chooseViedo.addAction(Recordvideo)
        chooseViedo.addAction(Choosethevideo)
        self.present(chooseViedo, animated: true, completion: nil)
    }
    //MARK:选择视频
    func Choosethevideo() -> Void {
        let viedeoVC = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
        viedeoVC?.didFinishPickingVideoHandle = {
            (img,asset) in
            self.Videoimg?.image = img
            let phAsset = asset as! PHAsset
            if phAsset.mediaType.rawValue == 2 {
                let options = PHVideoRequestOptions()
                options.version = PHVideoRequestOptionsVersion(rawValue: 0)!
                options.deliveryMode =   PHVideoRequestOptionsDeliveryMode(rawValue: 0)!
                let manager = PHImageManager()
                manager.requestAVAsset(forVideo: phAsset, options: options, resultHandler: { (asset, audioMix, info) in
                    self.isVideoCompression = true
                    self.VideoDataArray.removeAll()
                    self.VideoTypeArray.removeAll()
                    let urlAsset = asset as! AVURLAsset
                    let url = urlAsset.url
                    self.compressedVideoOtherMethod(URL: url, compressionType: "AVAssetExportPresetLowQuality")
                })
            }
        }
        self.present(viedeoVC!, animated: true, completion: nil)
    }
    //MARK:视频压缩
    func compressedVideoOtherMethod(URL:URL,compressionType:String) -> Void {
        let data = NSData.init(contentsOf: URL)
        let totalSize = Float((data?.length)! / 1024 / 1024)
        print("视频总大小:\(totalSize)MB")
        let avAsset = AVURLAsset(url: URL, options: nil)
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        // 所支持的压缩格式中是否有 所选的压缩格式
        if compatiblePresets.contains(compressionType) {
            let exportSession = AVAssetExportSession.init(asset: avAsset, presetName: compressionType)
            let formater = DateFormatter.init()
            //用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
            formater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            let manager = FileManager.default
            let isExists = manager.fileExists(atPath: CompressionVideoPaht)
            if !isExists {
                try? manager.createDirectory(atPath: CompressionVideoPaht, withIntermediateDirectories: true, attributes: nil)
            }
            let time = formater.string(from: NSDate() as Date)
            let resultPath = "\(CompressionVideoPaht)/outputJFVideo-\(time).mp4"
            print(resultPath)
            exportSession?.outputURL = NSURL.fileURL(withPath: resultPath)
            exportSession?.outputFileType = AVFileTypeMPEG4
            exportSession?.shouldOptimizeForNetworkUse = true
            exportSession?.exportAsynchronously(completionHandler: {
                if (exportSession?.status == AVAssetExportSessionStatus.completed) {
                    let data = NSData.init(contentsOfFile: resultPath)
                    let memorySize = Float((data?.length)! / 1024 / 1024)
                    print("视频压缩后大小 \(memorySize)MB")
                    self.VideoDataArray.append(data as Any)
                    self.VideoTypeArray.append("mp4")
                    self.SuccessTost(Title: "", Body: "视频压缩完成")
                } else {
                    print("压缩失败")
                }
            })
        } else {
            print("不支持 \(compressionType)格式的压缩")
        }
    }
}
