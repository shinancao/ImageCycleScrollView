//
//  ViewController.swift
//  ImageCycleScrollViewDemo
//
//  Created by zhangnan on 2017/7/5.
//  Copyright © 2017年 ZhangNan. All rights reserved.
//

import UIKit
import ImageCycleScrollView

class ViewController: UIViewController {
    let cycleScrollView: ImageCycleScrollView = {
        let `self` = ImageCycleScrollView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 177))
        self.pageControlShowStyle = .center
        self.pageControl?.currentPageIndicatorTintColor = UIColor.purple
        return self
    }()
    
    @IBOutlet weak var cycleScrollView_sb: ImageCycleScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(cycleScrollView)
        
        let testImageUrls = ["http://ojx1pmrk7.bkt.clouddn.com/ALetterToMe.jpg", "http://ojx1pmrk7.bkt.clouddn.com/Me-Pressent-Future.jpg", "http://ojx1pmrk7.bkt.clouddn.com/Not-Always-May.jpg", "http://ojx1pmrk7.bkt.clouddn.com/Reveal-App-Layout.jpg"]
        
        cycleScrollView.imageUrls = testImageUrls
        
        cycleScrollView_sb.pageControlShowStyle = .left
        cycleScrollView_sb.changeImageTime = 1.0
        cycleScrollView_sb.imageUrls = testImageUrls
        cycleScrollView_sb.clickCallback = {[weak self](scrollView: ImageCycleScrollView, imgIndex: Int) -> Void in
            if let strongSelf = self {
                print(strongSelf)
                print("index: \(imgIndex)") //index从1开始
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

