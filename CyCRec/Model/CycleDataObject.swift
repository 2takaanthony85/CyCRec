//
//  CycleDataObject.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/24.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import RealmSwift

class CycleDataObject: Object {
    @objc dynamic var CycleID: Int = 0
    //タイマーで使用していたcount
    @objc dynamic var count: Int = 0
    //00:00:00
    @objc dynamic var timeScore: String = ""
    //距離
    @objc dynamic var distance: Double = 0
    //最高時速
    @objc dynamic var maxSpeed: Double = 0
    //平均時速
    @objc dynamic var averageSpeed: Double = 0
    //走行日
    @objc dynamic var date: NSDate = NSDate()
}
