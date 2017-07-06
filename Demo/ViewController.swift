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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(cycleScrollView)
        
        cycleScrollView.imageUrls = ["http://ojx1pmrk7.bkt.clouddn.com/ALetterToMe.jpg", "http://ojx1pmrk7.bkt.clouddn.com/Me-Pressent-Future.jpg", "http://ojx1pmrk7.bkt.clouddn.com/Not-Always-May.jpg", "http://ojx1pmrk7.bkt.clouddn.com/Reveal-App-Layout.jpg"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

