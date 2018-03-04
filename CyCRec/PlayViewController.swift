//
//  PlayViewController.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/02/25.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit
import MapKit

class PlayViewController: UIViewController {

    //地図
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        
        //ScreenSize.swiftより呼び出し
        let scSize = ScreenSize()
        var size = Sizing()
        var mapSize = size.mapViewSize(screenHeight: Int(scSize.height))
        
        mapView.frame = CGRect(x: 0, y: mapSize.y, width: Int(scSize.width), height: mapSize.height)
        
        return mapView
    }()
    
    //時間
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        
        let scSize = ScreenSize()
        timeLabel.frame = CGRect(x: scSize.leftLabel_x, y: scSize.topLabel_y, width: Int((scSize.width - 6.0) / 2), height: scSize.labelHeight)

        timeLabel.backgroundColor = UIColor.white
        timeLabel.text = "10:30:35"
        timeLabel.textColor = UIColor.black
        timeLabel.textAlignment = .right
        return timeLabel
    }()
    
    //距離
    private let distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        
        let scSize = ScreenSize()
        distanceLabel.frame = CGRect(x: scSize.leftLabel_x, y: scSize.bottomLabel_y, width: Int((scSize.width - 6.0) / 2), height: scSize.labelHeight)
        
        distanceLabel.backgroundColor = UIColor.white
        distanceLabel.text = "123.45 km"
        distanceLabel.textColor = UIColor.black
        distanceLabel.textAlignment = .right
        return distanceLabel
    }()
    
    //最高時速
    private let maxSpeedlabel: UILabel = {
        let maxSpeedLabel = UILabel()
        
        let scSize = ScreenSize()
        maxSpeedLabel.frame = CGRect(x: Int(scSize.width / 2 + 1), y: scSize.topLabel_y, width: Int((scSize.width - 6.0) / 2), height: scSize.labelHeight)

        maxSpeedLabel.backgroundColor = UIColor.white
        maxSpeedLabel.text = "567.98 km/h"
        maxSpeedLabel.textColor = UIColor.black
        maxSpeedLabel.textAlignment = .right
        return maxSpeedLabel
    }()
    
    //平均時速
    private let averageSpeedLabel: UILabel = {
        let averageSpeedLabel = UILabel()
        
        let scSize = ScreenSize()
        averageSpeedLabel.frame = CGRect(x: Int(scSize.width / 2 + 1), y: scSize.bottomLabel_y, width: Int((scSize.width - 6.0) / 2), height: scSize.labelHeight)

        averageSpeedLabel.backgroundColor = UIColor.white
        averageSpeedLabel.text = "678.56 km/h"
        averageSpeedLabel.textColor = UIColor.black
        averageSpeedLabel.textAlignment = .right
        return averageSpeedLabel
    }()
    
    //スタートボタン
    private let startButton: UIButton = {
        let startButton = UIButton()
        
        //ScreenSize.swiftより呼び出し
        let scSize = ScreenSize()
        var size = Sizing()
        var buttonSize = size.mapViewSize(screenHeight: Int(scSize.height))
        
        startButton.frame = CGRect(x: 0, y: Int(buttonSize.height + scSize.header), width: Int(scSize.width / 2), height: scSize.labelHeight)
        
        startButton.backgroundColor = UIColor.orange
        return startButton
    }()
    
    //ストップボタン
    private let stopButton: UIButton = {
        let stopButton = UIButton()
        
        //ScreenSize.swiftより呼び出し
        let scSize = ScreenSize()
        var size = Sizing()
        var buttonSize = size.mapViewSize(screenHeight: Int(scSize.height))
        
        
        stopButton.frame = CGRect(x: Int(scSize.width / 2), y: Int(buttonSize.height + scSize.header), width: Int(scSize.width / 2), height: scSize.labelHeight)

        stopButton.backgroundColor = UIColor.MainColor()
        return stopButton
    }()
    
    //クローズボタン
    //private let closeButton...ではPlayViewControllerのプロパティは初期化されていないためにselfなど使用できない
    //lazy var (遅延評価？？)にするとできる... よくわからない...
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        
        //ScreenSize.swiftより呼び出し
        let scSize = ScreenSize()
        var size = Sizing()
        var buttonSize = size.mapViewSize(screenHeight: Int(scSize.height))
        
        //
        closeButton.frame = CGRect(x: 0, y: Int(buttonSize.height + scSize.header + scSize.labelHeight), width: Int(scSize.width), height: scSize.labelHeight)
        
        closeButton.backgroundColor = UIColor.white
        closeButton.setTitle("close", for: .normal)
        closeButton.setTitleColor(UIColor.blue, for: .normal)
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        return closeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mapView)
        self.view.addSubview(timeLabel)
        self.view.addSubview(distanceLabel)
        self.view.addSubview(maxSpeedlabel)
        self.view.addSubview(averageSpeedLabel)
        self.view.addSubview(startButton)
        self.view.addSubview(stopButton)
        
        //closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(closeButton)

    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



