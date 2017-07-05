//
//  ImageCycleScrollView.swift
//  ImageCycleScrollViewDemo
//
//  Created by zhangnan on 2017/7/4.
//  Copyright © 2017年 ZhangNan. All rights reserved.
//

import UIKit
import Kingfisher

public enum UIPageControlShowStyle {
    case none
    case left
    case center
    case right
}

public typealias ImageCycleScrollViewClickCallback = (_ scrollView: ImageCycleScrollView, _ imgIndex: Int) -> Void

public class ImageCycleScrollView: UIScrollView, UIScrollViewDelegate {
    
    fileprivate var currentImage = 1
    
    fileprivate var leftImageView: UIImageView!
    fileprivate var centerImageView: UIImageView!
    fileprivate var rightImageView: UIImageView!
    
    fileprivate var moveTimer: Timer?
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    fileprivate var isTimeUp: Bool = false
    
    public var changeImageTime = 2.0
    
    public var placeholder: UIImage?
    
    public var clickCallback: ImageCycleScrollViewClickCallback?
    
    public private(set) var pageControl: UIPageControl?
    
    public var imageUrls: [String] = [] {
        didSet {
            let imageViewCollection = [leftImageView, centerImageView, rightImageView]
            
            imageViewCollection.forEach{ $0?.image = nil }
            
            for (urlStr, imgView) in zip(imageUrls, imageViewCollection) {
                imgView?.kf.setImage(with: URL(string: urlStr), placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            isScrollEnabled = imageUrls.count > 1
            
            if imageUrls.count > 1 {
                contentOffset = CGPoint(x: screenWidth, y: 0)
            } else {
                contentOffset = CGPoint(x: 0, y: 0)
            }
            
            currentImage = 1
            isTimeUp = false
            
            moveTimer?.invalidate()
            moveTimer = nil
            
            if isScrollEnabled {
                moveTimer = Timer.zn_scheduledTimer(timerInterval: changeImageTime, repeats: true) {[weak self] _ in
                    
                    self?.animalMoveImage()
                }
            }
            
            setupPageCtrlPos()
        }
    }
    
    public var pageControlShowStyle: UIPageControlShowStyle = .none {
        didSet {
            if pageControlShowStyle != .none {
                pageControl = UIPageControl()
                pageControl?.isEnabled = false
                pageControl?.currentPage = 0
                superview?.addSubview(pageControl!)
            } else {
                pageControl?.isHidden = true
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initailize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initailize()
    }
    
    func initailize() {
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self
        
        leftImageView = UIImageView()
        centerImageView = UIImageView()
        rightImageView = UIImageView()
        
        [leftImageView, centerImageView, rightImageView].forEach { (imgView) in
            addSubview(imgView)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    override public func layoutSubviews() {
        
        contentSize = CGSize(width: screenWidth * 3, height: screenHeight)
        leftImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        centerImageView.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        rightImageView.frame = CGRect(x: screenWidth * 2, y: 0, width: screenWidth, height: screenHeight)
        super.layoutSubviews()
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let pageControl = pageControl, pageControl.superview == nil {
            superview?.addSubview(pageControl)
        }
    }
    
    @objc func animalMoveImage() {
        setContentOffset(CGPoint(x: screenWidth * 2, y: 0), animated: true)
        isTimeUp = true
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(resetImagePos), userInfo: nil, repeats: false)
    }
    
    @objc func resetImagePos() {
        scrollViewDidEndDecelerating(self)
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        if let callback = clickCallback {
            callback(self, currentImage)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageCycleScrollView {
    // MARK: 图片停止时，调用该函数使得滚动视图复用
    @objc public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if contentOffset.x == 0 {
            
            currentImage = (currentImage - 1) % imageUrls.count
            if let pageControl = pageControl {
                pageControl.currentPage = (pageControl.currentPage - 1) % imageUrls.count
            }
            
        } else if contentOffset.x == screenWidth * 2 {
            
            currentImage = (currentImage + 1) % imageUrls.count
            if let pageControl = pageControl {
                pageControl.currentPage = (pageControl.currentPage + 1) % imageUrls.count
            }
            
        } else {
            return
        }
        
        var index = currentImage == 0 ? imageUrls.count - 1 : (currentImage - 1) % imageUrls.count
        
        leftImageView.kf.setImage(with: URL(string: imageUrls[index]), placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
        
        index = currentImage % imageUrls.count
        centerImageView.kf.setImage(with: URL(string: imageUrls[index]), placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
        
        index = (currentImage + 1) % imageUrls.count
        rightImageView.kf.setImage(with: URL(string: imageUrls[index]), placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
        
        contentOffset = CGPoint(x: screenWidth, y: 0)
        
        if !isTimeUp {
            moveTimer?.fireDate = Date(timeIntervalSinceNow: changeImageTime)
        }
        
        isTimeUp = false
    }
}

fileprivate extension ImageCycleScrollView {
    func setupPageCtrlPos() {
        guard let pageControl = pageControl else {
            return
        }
        
        if imageUrls.count < 2 {
            pageControlShowStyle = .none
            return
        }
        
        pageControl.numberOfPages = imageUrls.count
        
        let w = CGFloat(20 * pageControl.numberOfPages)
        pageControl.frame = CGRect(x: 0, y: 0, width: w, height: 20.0)
        
        switch pageControlShowStyle {
        case .none:
            break
        case .left:
            pageControl.center = CGPoint(x: originX + w/2.0, y: originY+screenHeight - 10)
        case .center:
            pageControl.center = CGPoint(x: superViewWidth/2.0, y: originY+screenHeight - 10)
        case .right:
            pageControl.center = CGPoint(x: originX + screenWidth - w/2.0, y: originY+screenHeight - 10)
        }
    }
}

extension ImageCycleScrollView {
    var screenWidth: CGFloat {
        return bounds.size.width
    }
    
    var screenHeight: CGFloat {
        return bounds.size.height
    }
    
    var originY: CGFloat {
        return frame.origin.y
    }
    
    var originX: CGFloat {
        return frame.origin.x
    }
    
    var superViewWidth: CGFloat {
        return (superview?.bounds.size.width)!
    }
}


