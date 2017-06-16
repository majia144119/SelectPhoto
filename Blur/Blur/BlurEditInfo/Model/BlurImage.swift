//
//  BlurImage.swift
//  Blur
//
//  Created by 马嘉 on 2017/6/15.
//  Copyright © 2017年 马嘉. All rights reserved.
//

import UIKit

extension  UIImageView {

    
    struct RuntimeKey {
        static let mjTag = UnsafeRawPointer.init(bitPattern: "mjTag".hashValue)
        
    }
    
    var mjTag: Int? {
        set {
            objc_setAssociatedObject(self, UIImageView.RuntimeKey.mjTag, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return  objc_getAssociatedObject(self, UIImageView.RuntimeKey.mjTag) as? Int
        }
    }

}

