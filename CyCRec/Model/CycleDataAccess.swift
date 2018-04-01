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
    func sortData(key: String, ascend: Bool) -> [CycleDataModel]
    func setData(object: CycleDataObject) -> CycleDataModel
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
        //Double型のデータは小数第2位以下は切り捨て
        dataObject.distance = floor(dataModel.distance * 100) / 100
        dataObject.maxSpeed = floor(dataModel.maxSpeed * 100) / 100
        dataObject.averageSpeed = floor(dataModel.averageSpeed * 100) / 100
        dataObject.date = dataModel.date()
        
        try! realm.write {
            realm.add(dataObject)
        }
    }
    
    func sortData(key: String, ascend: Bool) -> [CycleDataModel] {
        let realm = try! Realm()
        let results = realm.objects(CycleDataObject.self).sorted(byKeyPath: key, ascending: ascend)
        var dataModel: [CycleDataModel] = []
        for result in results {
            dataModel.append(setData(object: result))
        }
        return dataModel
    }
    
    func setData(object: CycleDataObject) -> CycleDataModel {
        let dataModel = CycleDataModel(count: object.count,
                                       timeScore: object.timeScore,
                                       distance: object.distance,
                                       maxSpeed: object.maxSpeed,
                                       averageSpeed: object.averageSpeed) { () -> String in
                                        return object.date
        }
        return dataModel
    }
}
