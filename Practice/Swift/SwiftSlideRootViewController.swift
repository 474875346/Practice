//
//  SwiftLideRootViewController.swift
//  QQSlideViewController
//
//  Created by Charles on 16/9/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

import UIKit


let kAnimationDuration: CGFloat = 0.3
let kMainViewOriginTransX: CGFloat = 0.0

class SwiftSlideRootViewController: UIViewController {
    
    var trans: CGFloat = 0.0
    
    var leftVc: UIViewController!
    var mainVc: UIViewController!
    var slideTranlationX: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     构造方法
     */
    init(leftVc: UIViewController, mainVc: UIViewController, slideTranlationX: CGFloat) {
        
        super.init(nibName: nil, bundle: nil)
        self.slideTranlationX = SCREEN_WIDTH/4*3
        if (slideTranlationX < 200 || slideTranlationX == 0) {
            self.slideTranlationX = SCREEN_WIDTH/4*3
        }  else if (slideTranlationX > 0 && slideTranlationX < 100) {
            self.slideTranlationX = 100
        }
        self.addChildViewController(leftVc)
        self.addChildViewController(mainVc)
        
        self.leftVc = leftVc
        self.mainVc = mainVc
        
        
    }
    init(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(self.leftVc!.view)
        view.addSubview(self.mainVc!.view)
        self.view.backgroundColor = UIColor.white
        self.leftVc.view.frame = CGRect(x: kMainViewOriginTransX, y: 0, width: self.slideTranlationX, height: self.view.height)
        self.mainVc.view.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = RGBA(247, g: 247, b: 247, a: 1.0)
        // 添加手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGest(_:)))
        view.addGestureRecognizer(pan)        
    }
    
    /**
     侧滑
     */
    func slideToLeft() {
        self.updateContransWithTransX(self.slideTranlationX, animated: true)
    }
    
    /**
     返回初始样式
     */
    func slideBack() {
        self.updateContransWithTransX(0, animated: true)
    }
    
    func updateContransWithTransX(_ tx: CGFloat, animated: Bool)  {
        self.trans = tx
        if animated == true { // 有动画
            
            UIView.animate(withDuration: TimeInterval(kAnimationDuration), animations: {
                
                self.mainVc.view.x = self.trans
                self.mainVc.view.alpha = (SCREEN_WIDTH - self.trans * 0.5 ) / SCREEN_WIDTH * 1.0
//                let scale: CGFloat = 1.0 - 0.1 * self.trans / CGFloat(self.slideTranlationX)
//                self.leftVc.view.transform = CGAffineTransform(scaleX: scale, y: scale)
                }, completion: { (_) in
                    
                    if self.trans == self.slideTranlationX {
                        self.addCover()
                    } else {
                        var button = self.mainVc.view.viewWithTag(101) as? UIButton
                        button?.removeFromSuperview()
                        button = nil
                    }
                    
            })
            
        } else { // 无动画
            self.mainVc.view.x = self.trans
            self.mainVc.view.alpha = (SCREEN_WIDTH - self.trans * 0.5 ) / SCREEN_WIDTH * 1.0
//            let scale: CGFloat = 1.0 - 0.1 * self.trans / CGFloat(self.slideTranlationX)
//            self.leftVc.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            if self.trans == self.slideTranlationX {
                self.addCover()
            } else {
                var button = self.mainVc.view.viewWithTag(101) as? UIButton
                button?.removeFromSuperview()
                button = nil
            }
        }
    }
    
    func addCover() {
        
        if (self.mainVc.view.viewWithTag(101) != nil) {
            return ;
        }
        
        let button = UIButton(type: .custom)
        button.tag = 101
        button.backgroundColor = UIColor.black
        button.alpha = 0.3
        mainVc.view.addSubview(button)
        button.frame = mainVc.view.bounds
        button.addTarget(self, action: #selector(self.backBtnTouch(_:)), for: .touchUpInside)
    }
    
    /**
     点击遮罩
     */
    func backBtnTouch(_ btn: UIButton) {
        if mainVc.view.x < self.slideTranlationX {
            return ;
        }
        self.updateContransWithTransX(kMainViewOriginTransX, animated: true)
    }
    
    /**
     滑动手势响应
     */
    func panGest(_ gest: UIPanGestureRecognizer) {
        if self.mainVc.view.x == self.slideTranlationX {
            let point = gest.location(in: view)
            if CGRect(x: 0, y: 0, width: self.slideTranlationX, height: SCREEN_HEIGHT).contains(point) {
                return ;
            }
        }
        if gest.view!.isEqual(self.view) == false {
            return ;
        }
        
        if gest.state == .began || gest.state == .changed {
            let translation = gest.translation(in: view)
            if translation.x < 0 {
                // 左滑
                if self.mainVc.view.x >= 0 {
                    self.trans += translation.x
                    if self.trans < kMainViewOriginTransX {
                        self.trans = kMainViewOriginTransX
                    }
                    
                    self.updateContransWithTransX(self.trans, animated: false)
                }
            } else {
                // 右滑
                self.trans += translation.x
                if self.trans > self.slideTranlationX {
                    self.trans = self.slideTranlationX
                }
                self.updateContransWithTransX(self.trans, animated: false)
            }
            gest.setTranslation(CGPoint.zero, in: view)
            
        }
        if gest.state == .ended {
            
            if self.trans > self.slideTranlationX * 0.5 && trans <= self.slideTranlationX {
                self.trans = self.slideTranlationX
                self.updateContransWithTransX(self.trans, animated: true)
            } else if (self.trans <= self.slideTranlationX * 0.5) {
                self.trans = kMainViewOriginTransX
                self.updateContransWithTransX(self.trans, animated: true)
            }
        }
    }
}
