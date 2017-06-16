//
//  BlurColor.swift
//  Blur
//
//  Created by 马嘉 on 2017/6/15.
//  Copyright © 2017年 马嘉. All rights reserved.
//

import UIKit

extension UIColor {
    static func withHex(hexInt hex:Int32, alpha:CGFloat = 1) -> UIColor {
        let r = CGFloat((hex & 0xff0000) >> 16) / 255
        let g = CGFloat((hex & 0xff00) >> 8) / 255
        let b = CGFloat(hex & 0xff) / 255
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }

}
