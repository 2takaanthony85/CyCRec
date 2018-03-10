//
//  ScreenSize.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/04.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import UIKit

//struct？？
struct Sizing {
    
    private var size: (Int, Int) = (0,0)
    
    //mapViewのサイズを決定する
    mutating func mapViewSize(screenHeight: Int) -> (y: Int, height: Int){
        
        switch screenHeight {
        //iPhone SE
        case 568:
            //size = (100, 368)
            //縦 - 20
            size = (20, 448)
            return size
        //iPhone8 Plusなど
        case 736:
            //size = (100, 536)
            //縦 - 20
            size = (20, 616)
            return size
        //iPhone8など
        case 667:
            //size = (100, 467)
            //縦 - 20
            size = (20, 547)
            return size
        //iPhoneX
        case 812:
            //size = (100, 612)
            //縦 - 20
            size = (20, 692)
            return size
        default:
            size = (10, 280)
            return size
        }
    }
}

//もっと良い表現はないものか。。。
class ScreenSize {
    
    let height: CGFloat = UIScreen.main.bounds.height
    let width: CGFloat = UIScreen.main.bounds.width
    
    //画面左に位置するラベルのx座標
    let leftLabel_x = 2
    //画面上に位置するラベルのy座標
    let topLabel_y = 20
    //topLabelの下に位置するラベルのy座標
    let bottomLabel_y = 72
    //ラベルの高さ
    let labelHeight = 50
    //ヘッダー
    let header = 20
    
}
