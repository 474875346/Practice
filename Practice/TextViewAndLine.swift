//
//  TextViewAndLine.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/9.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class TextViewAndLine: UIView,UITextViewDelegate {
    var contTextView : UITextView?
    var placeHolderLabel : UILabel?
    convenience init(title: String){
        self.init()!
        print(title)
    }
    init(frame:CGRect,title:NSString,planceholder:NSString) {
        super.init(frame: frame)
        let titleLabel = CreateUI.Label(UIColor.black, backgroundColor: UIColor.clear, title: title as String, frame: CGRect(x: 10, y: 0, width: 80, height: 30), font: 17)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        contTextView = UITextView(frame: CGRect(x: XW(titleLabel)+10, y: 0, width:  SCREEN_WIDTH - XW(titleLabel) - 10, height: 100))
        contTextView?.delegate = self
        self.addSubview(contTextView!)
        placeHolderLabel = CreateUI.Label(UIColor.lightGray, backgroundColor: UIColor.clear, title: planceholder as String, frame: CGRect(x: 0, y: 0, width: W(contTextView!), height: 30), font: 17)
        contTextView?.addSubview(placeHolderLabel!)
        let line = CreateUI.Label(UIColor.clear, backgroundColor: UIColor.lightGray, title: "", frame: CGRect(x: 0, y: YH(contTextView!), width: SCREEN_WIDTH, height: 1), font: 0)
        self.addSubview(line)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let Text = text as NSString
        if !Text.isEqual(to: "") {
            if textView.isEqual(contTextView) {
                placeHolderLabel?.isHidden = true
            }
        }
        if Text.isEqual(to: "") && range.length == 1 && range.location == 0 {
            if textView.isEqual(contTextView) {
                placeHolderLabel?.isHidden = false
            }
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        let text  = textView.text as NSString
        if !text.isEqual(to: "") {
            if textView.isEqual(contTextView) {
                placeHolderLabel?.isHidden = true
            }
        }
    }
    required init?(coder aDecoder: NSCoder?=nil) {
        fatalError("init(coder:) has not been implemented")
    }
}
