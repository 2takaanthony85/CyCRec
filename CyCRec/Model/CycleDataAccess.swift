//
//  CycleDataAccess.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/25.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct realmDataAccess {
    
    //let realm = try! Realm()
    
    //realmに計測データを保存
    func saveData(timer: MeasureTimer, distance: MeasureDistance, speed: MeasureSpeed) {
        
        let dataModel = CycleData(count: timer.count,
                                  timeScore: timer.timeText,
                                  distance: distance.totalDistance,
                                  maxSpeed: speed.maxSpeed,
                                  averageSpeed: speed.average,
                                  date: { () -> String in
                                    let today = NSDate()
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "ja_JP")
                                    dateFormatter.dateFormat = "yyyy年MM月dd日(E)"
                                    return dateFormatter.string(from: today as Date)
        })
        
        //もう少し綺麗に書きたい。。。
        let realm = try! Realm()
        let dataObject = CycleDataObject.create()
        dataObject.count = dataModel.count
        dataObject.timeScore = dataModel.timeScore
        dataObject.distance = dataModel.distance
        dataObject.maxSpeed = dataModel.maxSpeed
        dataObject.averageSpeed = dataModel.averageSpeed
        dataObject.date = dataModel.date()
            
        try! realm.write {
            realm.add(dataObject)
        }
    }
    
    //全取得(日付順)
    func sortData() -> [CycleDataObject] {
        let realm = try! Realm()
        let results = realm.objects(CycleDataObject.self).sorted(byKeyPath: "CycleID", ascending: true)
        var dataObjects: [CycleDataObject] = []
        for result in results {
            dataObjects.append(result)
        }
        return dataObjects
    }
    
    //速さのソート(平均時速での比較)
    func sortSpeed() -> [CycleDataObject] {
        let realm = try! Realm()
        let results = realm.objects(CycleDataObject.self).sorted(byKeyPath: "averageSpeed", ascending: false)
        var dataObjects: [CycleDataObject] = []
        for result in results {
            dataObjects.append(result)
        }
        return dataObjects
    }
    
    //距離のソート(距離が長い順)
    func sortDistance() -> [CycleDataObject] {
        let realm = try! Realm()
        let results = realm.objects(CycleDataObject.self).sorted(byKeyPath: "distance", ascending: false)
        var dataObjects: [CycleDataObject] = []
        for result in results {
            dataObjects.append(result)
        }
        return dataObjects
    }
    
}
