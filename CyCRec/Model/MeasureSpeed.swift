//
//  MeasureSpeed.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/10.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import CoreLocation

struct MeasureSpeed {
    
    //平均時速を取得するために使用する配列
    //最終的にmaxSpeedをこの配列から取得する
    //realTimeSpeedを入れていく
    var speedBox: [Double] = []
    
    //最新の時速
    var realTimeSpeed: Double
    
    //平均時速
    var average: Double {
        get {
            guard self.speedBox.count > 0 else {
                return 0
            }
            return self.speedBox.reduce(0) { $0 + $1 } / Double(exactly: self.speedBox.count)!
        }
    }
    
    //最高時速
    var maxSpeed: Double {
        get {
//            var first = speedBox[0]
//            for speed in speedBox {
//                if first < speed {
//                    first = speed
//                }
//            }
//            return first
            return 56.90
        }
    }
    
    init() {
        self.realTimeSpeed = 0
    }
    
    //リアルタイムの時速を計測
    mutating func realTimeSpeed(location: CLLocation) {
        self.realTimeSpeed = location.speed * 3.6
        self.speedBox.append(self.realTimeSpeed)
    }
    
    
}
