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
    
}
