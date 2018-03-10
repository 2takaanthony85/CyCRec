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
    //realTimeSpeedを入れていく
    var speedBox: [Double] = []
    
    //最新の時速
    var realTimeSpeed: Double
    
    //平均時速
    var average: Double {
        mutating get {
            //self.speedBox.append(self.realTimeSpeed)
            guard self.speedBox.count > 0 else {
                return 0
            }
            return self.speedBox.reduce(0) { $0 + $1 } / Double(exactly: self.speedBox.count)!
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
