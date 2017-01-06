//
//  HomePageViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/3.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class HomePageViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    let imgArray = ["qiandao","qiandaojilu","yuebao","yuebaojilu"]
    let titleArray = ["签到","签到记录","月报","月报记录"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "主页")
        self.CreateUI()
    }
    // #MARK: --UICollectionViewDataSource的代理方法
    /**
     - 该方法是可选方法，默认为1
     - returns: CollectionView中section的个数
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     - returns: Section中Item的个数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    /**
     - returns: 绘制collectionView的cell
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! HomeCollectionViewCell
        cell.HomeImg.image = UIImage(named: imgArray[indexPath.row])
        cell.HomeImg.contentMode = UIViewContentMode(rawValue: 1)!
        cell.HomeTitle.text = titleArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let VC = SignInViewController()
            VC.modalTransitionStyle = UIModalTransitionStyle(rawValue: 3)!
            self.present(VC, animated: true, completion: nil)
            break
        case 1:
            let VC = SignInRecordViewController()
            VC.modalTransitionStyle = UIModalTransitionStyle(rawValue: 3)!
            self.present(VC, animated: true, completion: nil)
            break
        case 2:
            let VC = MonthlyReportViewController()
            VC.modalTransitionStyle = UIModalTransitionStyle(rawValue: 3)!
            self.present(VC, animated: true, completion: nil)
            break
        default:
            let VC = MonthlyRecordViewController()
            VC.modalTransitionStyle = UIModalTransitionStyle(rawValue: 3)!
            self.present(VC, animated: true, completion: nil)
            break
        }
    }
}
private extension HomePageViewController {
    func CreateUI() -> Void {
        //定义collectionView的布局类型，流布局
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: SCREEN_WIDTH/4, height: 100)
        //滑动方向 默认方向是垂直
        layout.scrollDirection = .vertical
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = 0
        //每行之间最小的间距
        layout.minimumLineSpacing = 0
        let HomecollectionView = UICollectionView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), collectionViewLayout: layout)
        HomecollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        HomecollectionView.backgroundColor = UIColor.white
        HomecollectionView.delegate = self
        HomecollectionView.dataSource = self
        self.view.addSubview(HomecollectionView)
    }
}
