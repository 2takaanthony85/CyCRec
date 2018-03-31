//
//  CycleDataAccess.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/31.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import RealmSwift

protocol CycleDataSource {
    func saveData(timer: MeasureTimer, distance: MeasureDistance, speed: MeasureSpeed)
    func sortData(key: String, ascend: Bool) -> [CycleDataObject]
}

struct CycleDataAccess: CycleDataSource {
    
    func saveData(timer: MeasureTimer, distance: MeasureDistance, speed: MeasureSpeed) {
        
        let dataModel = CycleDataModel(count: timer.count,
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
    
    func sortData(key: String, ascend: Bool) -> [CycleDataObject] {
        let realm = try! Realm()
        let results = realm.objects(CycleDataObject.self).sorted(byKeyPath: key, ascending: ascend)
        var dataObjects: [CycleDataObject] = []
        for result in results {
            dataObjects.append(result)
        }
        return dataObjects
    }
    
}
