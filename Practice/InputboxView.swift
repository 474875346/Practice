//
//  InputboxView.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class InputboxView: UIView ,UITextViewDelegate{
    let textview = UITextView()
    var send:UIButton?
    var keyboardheight:CGFloat?
    var InputBlock:(()->Void)?
    var mHeightTextView:CGFloat = 44
    
    init(frame: CGRect,VC:UIViewController) {
        super.init(frame: frame)
        textview.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH-100, height: mHeightTextView)
        textview.font = UIFont.systemFont(ofSize: 24)
        textview.backgroundColor = RGBA(247, g: 247, b: 247, a: 1.0)
        textview.delegate = self
        self.addSubview(textview)
        send = UIButton(type: .custom)
        send?.frame = CGRect(x: SCREEN_WIDTH-100, y: 0, width: 100, height: 44)
        send?.addTarget(self, action: #selector((self.sendClick)), for: .touchUpInside)
        send?.setTitle("发送", for: .normal)
        send?.backgroundColor = RGBA(76, g: 176, b: 253, a: 1.0)
        send?.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(send!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension InputboxView {
    func textViewDidChange(_ textView: UITextView) {

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let size = textView.sizeThatFits(CGSize(width: SCREEN_WIDTH-100, height: 0))
        var content:CGFloat = 44
        if size.height > 110 {
            content = 110
            textView.isScrollEnabled = true
        } else {
            content = size.height
            textView.isScrollEnabled = false
        }
        if mHeightTextView != content  {
            self.textview.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH-100, height:content)
            self.frame = CGRect(x: 0, y: SCREEN_HEIGHT-content, width: SCREEN_WIDTH, height: content)
        }
        send?.frame = CGRect(x: SCREEN_WIDTH-100, y: H(self)-44, width: 100, height: 44)
        return true
    }
}
private extension InputboxView {
    @objc func sendClick() -> Void {
        self.InputBlock!()
    }
}
