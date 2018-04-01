//
//  UIColorExtension.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/04.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0 , green: CGFloat(g) / 255.0 , blue: CGFloat(b) / 255.0 , alpha: alpha)
    }
    
    class func MainColor() -> UIColor {
        return UIColor.rgb(r: 24, g: 135, b: 208, alpha: 1.0)
    }
    
    class func tableViewTextColor() -> UIColor {
        return UIColor.rgb(r: 388, g: 149, b: 0, alpha: 3.0)
    }
}

