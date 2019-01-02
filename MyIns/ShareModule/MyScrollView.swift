//
//  MyView.swift
//  MyIns
//
//  Created by LiYong on 2018/12/30.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class MyScrollView: UIScrollView {

//
//    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//
//
//        print("point:\(point)")
//        return self
//    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        touches.forEach { (touch) in
            
            let loction = touch.location(in: touch.view)
            
            print("touchesBegan:\(loction)")
            super.touchesBegan(touches, with: event)
            
            
            
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            
            let loction = touch.location(in: touch.view)
            
            print("touchesMoved:\(loction)")
            
            super.touchesMoved(touches, with: event)
            
            
        }
    }
    
    

}
