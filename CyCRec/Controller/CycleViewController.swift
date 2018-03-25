//
//  CycleViewController.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/18.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum Operation {
    case stop
    //case pause
    case close
}

class CycleViewController: UIViewController, CLLocationManagerDelegate, AlertDelegate {

    var playView: PlayView!
    let locationService = LocationService()
    var measureSpeed = MeasureSpeed()
    let measureTimer = MeasureTimer()
    var measureDistance = MeasureDistance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playView = PlayView(frame: CGRect(origin: .zero, size: self.view.frame.size))
        self.view.addSubview(playView)
        
        //マップを表示する際のズームレベル、縮尺を設定
        let span = MKCoordinateSpanMake(0.001, 0.001)
        //地図を表示する際の位置と広さを指定する
        let region = MKCoordinateRegionMake(playView.mapView.userLocation.coordinate, span)
        //地図の表示に反映させる
        playView.regionDecision(region: region)
    }
    
    //位置情報取得開始
    @objc func start() {
       locationService.startUpdatingLocation()
        
        if let latitude = locationService.locationManager.location?.coordinate.latitude, let longitude = locationService.locationManager.location?.coordinate.longitude {
            playView.dropPin(latitude: latitude, longitude: longitude)
        }
        
        measureTimer.startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeLabel(_:)), name: NSNotification.Name(rawValue: "updateTime"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)), name: NSNotification.Name(rawValue: "didUpdateLocation"), object: nil)
        
        playView.switchButton()
        playView.useEnabledStopButton()
    }
    
    //時間の表示
    @objc func updateTimeLabel(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        if let timeText = userInfo["time"] as? String {
            playView.timeLabel.text = timeText
        }
    }
    
    //新しい位置情報より速度と距離の計測
    @objc func updateData(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        if let newLocation = userInfo["location"] as? CLLocation {
            //2種類の時速を計測
            measureSpeed.realTimeSpeed(location: newLocation)
            //距離の計測
            measureDistance.locations.append(newLocation)
            //新しいデータに更新
            updateDataDisplay(measureSpeed.realTimeSpeed, measureSpeed.average, measureDistance.totalDistance)
        }
    
        //closure
        locationService.coordinate2DArrayAppend(locations: locationService.locationDataArray) { (newCoordinates) -> Void in
            playView.updatePolyLine(coordinates: newCoordinates)
        }
    }
    
    //DispatchQueue使いたい。。。使える場面なのではないか？
    //速度、距離のデータの更新
    func updateDataDisplay(_ speed: Double, _ average: Double, _ distance: Double) {
        playView.realtimeSpeedlabel.text = String(format: "%.2f km/h", speed)
        playView.averageSpeedLabel.text = String(format: "%.2f km/h", average)
        playView.distanceLabel.text = String(format: "%.2f km", distance)
    }
    
    //stop
    @objc func stop() {
        let operation = Operation.stop
        stopOperation()
        alertByOperation(operation)
    }
    
    //一時停止
    @objc func pause() {
        pauseOperation()
    }
    
    //閉じる
    @objc func close() {
        let operation = Operation.close
        alertByOperation(operation)
    }
    
    //pauseが押されたときに
    //タイマーの停止
    //locationServiceの停止
    //ボタンの切り替え
    func pauseOperation() {
        measureTimer.stopTimer()
        locationService.locationManager.stopUpdatingLocation()
        //startButtonに切り替え
        playView.switchButton()
    }
    
    //stop, closeがタップされたとき
    func stopOperation() {
        //pauseButtonがタップされている場合
        //startButtonが表示されている(statusはtrue)
        //タイマー、locationServiceは停止している
        if playView.buttonStatus {
            //何もしない
        } else {
            //pauseButtonがタップされていない
            //pauseButtonが表示されている
            //タイマー、locationServiceは動いている
            measureTimer.stopTimer()
            locationService.locationManager.stopUpdatingLocation()
            //pauseButtonからstartButtonに切り替える
            playView.switchButton()
        }
    }
    
    //AlertDelegate
    func ok(_ operation: Operation) {
        switch operation {
        case .close:
            self.dismiss(animated: true, completion: nil)
        case .stop:
            //保存の処理
            let realmAccess = realmDataAccess()
            realmAccess.saveData(timer: self.measureTimer, distance: self.measureDistance, speed: self.measureSpeed)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //Alert
    func alertByOperation(_ operation: Operation) {
        var alert = Alert.init(pattern: operation)
        alert.delegate = self
        alert.ShowAction(operation)
        present(alert.alertContoroller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
