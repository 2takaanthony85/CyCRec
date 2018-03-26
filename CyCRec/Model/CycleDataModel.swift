//
//  CycleDataModel.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/24.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation

protocol DataSource {
    func save()
    func sort()
}

//extension DataSource {
//    var objects: [CycleDataObject]
//    func save(object)
//}

struct CycleData {
    
    let count: Int
    let timeScore: String
    let distance: Double
    let maxSpeed: Double
    let averageSpeed: Double
    let date: () -> String
    
}

