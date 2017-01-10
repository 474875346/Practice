//
//  ImageScrollview.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/9.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import SDWebImage
class ImageScrollview: UIView ,UIScrollViewDelegate{
    var returnBlock:(()->Void)?
    var  titleLabel : UILabel?
    var  imgArray : NSArray?
    init(frame: CGRect,imgarray:NSArray,idx:Int,isURL:Bool) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        let scrollview = UIScrollView(frame: frame)
        scrollview.bounces = false
        scrollview.isPagingEnabled = true
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.contentSize = CGSize(width: SCREEN_WIDTH*ConversionCGFloat(imgarray.count), height: 0)
        scrollview.delegate = self
        self.addSubview(scrollview)
        scrollview.contentOffset = CGPoint(x: SCREEN_WIDTH*ConversionCGFloat(idx), y: 0)
        imgArray = imgarray
        imgarray.enumerateObjects({ (obj, i, stop) in
            let img = UIImageView(frame: CGRect(x: SCREEN_WIDTH*ConversionCGFloat(i), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            if isURL {
                img.sd_setImage(with: URL(string: obj as! String), placeholderImage: UIImage(named: "tab_home_blue"))
            } else {
                img.image = obj as? UIImage
            }
            img.contentMode = UIViewContentMode(rawValue: 1)!
            img.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.clickImage))
            img.addGestureRecognizer(singleTap)
            scrollview.addSubview(img)
        })
        titleLabel = CreateUI.Label(UIColor.white, backgroundColor: UIColor.clear, title: "\(idx+1)/\(imgarray.count)", frame: CGRect(x: SCREEN_WIDTH/2-60, y: SCREEN_HEIGHT-50, width: 120, height: 30), font: 15)
        titleLabel?.textAlignment = .center
        self.addSubview(titleLabel!)
    }
    func clickImage() -> Void {
        returnBlock!()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let X  = scrollView.contentOffset.x / SCREEN_WIDTH
        let page = Int(X)
        titleLabel?.text = "\(page+1)/\((imgArray?.count)!)"
    }
    required init?(coder aDecoder: NSCoder?=nil) {
        fatalError("init(coder:) has not been implemented")
    }
}
