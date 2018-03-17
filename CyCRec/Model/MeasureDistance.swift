//
//  MeasureDistance.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/10.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import CoreLocation

struct MeasureDistance {
    
    var locations: [CLLocation] = [] {
        didSet {
            guard locations.count >= 2 else {
                return
            }
            if let lastIndex = locations.last {
                let calc = locations[locations.count - 2].distance(from: lastIndex) / 1000
                distances.append(calc)
            }
        }
    }
    
    var distances: [Double] = []
    
    var totalDistance: Double {
        get {
            return distances.reduce(0) { $0 + $1 }
        }
    }
    
//    func totalDistance() -> Double {
//        return distances.reduce(0) { $0 + $1 }
//    }
    
/*
     let location: CLLocation = 0 {
        didSet {
            //oldValueとlocation(新しい値)で距離を計算
            //distances.appednd(上記の計算結果)
        }
     }
*/
    //var locations: [CLLocation] = []
    //合計値じゃなかった。。。
//    var distance: Double {
//        mutating get {
//            guard locations.count >= 2 else {
//                return 0
//            }
//            if let lastIndex = locations.last {
//                //.distanceでメートルを返す
//                // /1000でkmに変換
//                return locations[locations.count - 2].distance(from: lastIndex) / 1000
//            }
//            return self.distance
//        }
//    }
    
}
