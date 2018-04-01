//
//  DataDetailView.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/04/01.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

enum dataTitle: String {
    case date = "走行日"
    case time = "走行時間"
    case averageSpeed = "平均時速"
    case maxSpeed = "最高時速"
    case distance = "走行距離"
    
    static let dataTitles: [dataTitle] = [.date, .time, .averageSpeed, .maxSpeed, .distance]
}

class DataDetailView: UIView, movement {
    
    let screenSize = ScreenSize()
    var animationView: ChildView!
    
    init(frame: CGRect, model: CycleDataModel) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.MainColor()
        self.alpha = 1.9
        
        var i = 1
        for title in dataTitle.dataTitles {
            let label = UILabel(frame: CGRect(x: 25, y: 80 * i, width: 200, height: 50))
            label.text = title.rawValue + " : "
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            //label.tag = i
            self.addSubview(label)
            i += 1
        }
        
        var r = 1
        for data in dataTitle.dataTitles {
            let label = UILabel(frame: CGRect(x: Int(screenSize.width / 2.5),
                                              y: 80 * r + 20, width: 200, height: 50))
            switch data {
            case .date: label.text = model.date()
            case .time: label.text = model.timeScore
            case .averageSpeed: label.text = String(model.averageSpeed) + " km/h"
            case .maxSpeed: label.text = String(model.maxSpeed) + " km/h"
            case .distance: label.text = String(model.distance) + " km"
            }
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = UIColor.white
            self.addSubview(label)
            r += 1
        }
        
        animationView = ChildView(frame: CGRect(x: 0, y: screenSize.height - 100, width: 60, height: 60))
        animationView.delegate = self
        self.addSubview(animationView)
        
        animationView.animationSelfView()
    }
    
    func rightMove() {
        UIView.animate(withDuration: 8,
                       delay: 0.0,
                       options: .repeat,
                       animations: {
                        self.animationView.frame.origin.x = self.screenSize.width
        },
                       completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
