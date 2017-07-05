//
//  Timer+ZNBlocksSupport.swift
//  ZNAdScrollView
//
//  Created by zhangnan on 2017/6/29.
//  Copyright © 2017年 ZhangNan. All rights reserved.
//

import Foundation

extension Timer {
 
    static func zn_scheduledTimer(timerInterval: TimeInterval, repeats: Bool, block:(Timer) -> Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(zn_blockInvoke), userInfo: block, repeats: repeats)
    }
    
    @objc static func zn_blockInvoke(timer: Timer) {
        if let block = timer.userInfo as? ((Timer) -> Void) {
            block(timer)
        }
    }
}
