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
    static let realm = try! Realm()
    
    @objc dynamic var CycleID: Int = 0
    //time
    @objc dynamic var count: Int = 0
    @objc dynamic var timeScore: String = ""
    //走行距離
    @objc dynamic var distance: Double = 0
    //最高時速
    @objc dynamic var maxSpeed: Double = 0
    //平均時速
    @objc dynamic var averageSpeed: Double = 0
    //走行日
    @objc dynamic var date: String = ""
    
    override static func primaryKey() -> String? {
        return "CycleID"
    }
    
    static func create() -> CycleDataObject {
        let object = CycleDataObject()
        object.CycleID = lastID()
        return object
    }
    
    static func lastID() -> Int {
        if let object = realm.objects(CycleDataObject.self).last {
            return object.CycleID + 1
        } else {
            return 1
        }
    }
}

