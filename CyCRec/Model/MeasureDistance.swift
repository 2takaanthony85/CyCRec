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
    
    var locations: [CLLocation] = []
    
    var distance: Double {
        get {
            guard locations.count >= 2 else {
                return 0
            }
            if let lastIndex = locations.last {
                return locations[locations.count - 2].distance(from: lastIndex) / 1000
            }
            return self.distance
        }
    }
}
