//
//  PlayViewController.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/02/25.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlayViewController: UIViewController,CLLocationManagerDelegate {

    
//    let alertTitle = "close?"
//    let alertMessage = "記録を終了してしていいですか？（記録は保存されません）"
//    
//    //地図
//    private lazy var mapView: MKMapView = {
//        let mapView = MKMapView()
//        var mapSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
//        mapView.frame = CGRect(x: 0, y: mapSize.y, width: Int(screenSize.width), height: mapSize.height)
//        return mapView
//    }()
//    
//    //時間
//    private lazy var timeLabel: UILabel = {
//        let timeLabel = UILabel()
//        timeLabel.frame = CGRect(x: screenSize.leftLabel_x, y: screenSize.topLabel_y, width: Int(screenSize.width - 6.0), height: screenSize.labelHeight)
//        timeLabel.backgroundColor = UIColor.white
//        //課題：textが表示されない
//        timeLabel.text = "10:30:40"
//        timeLabel.textAlignment = .right
//        return timeLabel
//    }()
//    
//    //距離
//    private lazy var distanceLabel: UILabel = {
//        let distanceLabel = UILabel()
//        distanceLabel.frame = CGRect(x: screenSize.leftLabel_x, y: screenSize.bottomLabel_y, width: Int((screenSize.width - 6.0) / 2), height: screenSize.labelHeight)
//        distanceLabel.backgroundColor = UIColor.white
//        distanceLabel.text = "123.45 km"
//        distanceLabel.textColor = UIColor.black
//        distanceLabel.textAlignment = .right
//        return distanceLabel
//    }()
//    
//    //最高時速
//    private lazy var maxSpeedlabel: UILabel = {
//        let maxSpeedLabel = UILabel()
//        maxSpeedLabel.frame = CGRect(x: Int(screenSize.width / 2 + 1), y: screenSize.topLabel_y, width: Int((screenSize.width - 6.0) / 2), height: screenSize.labelHeight)
//        maxSpeedLabel.backgroundColor = UIColor.white
//        maxSpeedLabel.text = "567.98 km/h"
//        maxSpeedLabel.textColor = UIColor.black
//        maxSpeedLabel.textAlignment = .right
//        return maxSpeedLabel
//    }()
//    
//    //平均時速
//    private lazy var averageSpeedLabel: UILabel = {
//        let averageSpeedLabel = UILabel()
//        averageSpeedLabel.frame = CGRect(x: Int(screenSize.width / 2 + 1), y: screenSize.bottomLabel_y, width: Int((screenSize.width - 6.0) / 2), height: screenSize.labelHeight)
//        averageSpeedLabel.backgroundColor = UIColor.white
//        averageSpeedLabel.text = "678.56 km/h"
//        averageSpeedLabel.textColor = UIColor.black
//        averageSpeedLabel.textAlignment = .right
//        return averageSpeedLabel
//    }()
//

    var playView: PlayView!
    var myLocationManager: CLLocationManager!
    var measureSpeed = MeasureSpeed()
    let measureTimer = MeasureTimer()
    var measureDistance = MeasureDistance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        locationConfig(myLocationManager)
        
        playView = PlayView(frame: CGRect(origin: .zero, size: self.view.frame.size))
        self.view.addSubview(playView)

    }
    
    //CLLocationManagerの設定
    func locationConfig(_ locationManager: CLLocationManager) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
    }
    
    @objc func tappedStart() {

        //位置情報取得開始
        myLocationManager.startUpdatingLocation()
        //タップ時(スタート時)の位置情報を取得し、ピンを貼る
        playView.dropPin(latitude: (myLocationManager.location?.coordinate.latitude)!, longitude: (myLocationManager.location?.coordinate.longitude)!)
        
        //時間の計測開始
        measureTimer.startTimer()
        
        //pauseButtonに切り替え
        playView.switchButton()
        
        print("touched start")
    }
    
    //承認ステータスの変更を通知
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //位置情報サービスの使用が決定していない場合
        if status == CLAuthorizationStatus.notDetermined {
            //フォアグラウンド時、位置情報サービスの使用を許可
            myLocationManager.requestWhenInUseAuthorization()
        }
        //すでに位置情報サービスの使用が決定している場合（フォアグラウンド時の許可の場合）
        else if status == CLAuthorizationStatus.authorizedWhenInUse {
            //マップを表示する際のズームレベル、縮尺を設定
            let span = MKCoordinateSpanMake(0.001, 0.001)
            //地図を表示する際の位置と広さを指定する
            let region = MKCoordinateRegionMake(playView.mapView.userLocation.coordinate, span)
            //地図の表示に反映させる
            playView.regionDecision(region: region)
        }
    }
    
    //位置情報の取得が更新されるたびに呼び出される
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //最新の位置情報をnewLocationに、、、locationsには少なくとも現在の位置を表す1つのオブジェクトが入っている
        guard let newLocation = locations.last else {
            return
        }
        
        //指定された座標値が有効かどうか判定
        if !CLLocationCoordinate2DIsValid(newLocation.coordinate) {
            return
        }
        
        //2種類の時速を計測
        measureSpeed.realTimeSpeed(location: newLocation)
        
        //距離の計測
        measureDistance.locations.append(newLocation)
        
    }
    
    //位置情報の取得に失敗した時の場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }

    //一時停止
    @objc func pause() {
        //一時停止時の位置情報を取得する
        if let newlocation = myLocationManager.location {
            measureDistance.locations.append(newlocation)
        }
        //タイマーを止める
        measureTimer.stopTimer()
        //位置情報の取得を止める
        myLocationManager.stopUpdatingLocation()
        //startButtonに切り替え
        playView.switchButton()
        print("touched pause")
    }
//
//    @objc func stop() {
//        print("touched stopButton")
//    }
//
//    @objc func close() {
//
//        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "OK", style: .default) { (okAction: UIAlertAction!) in
//            self.dismiss(animated: true, completion: nil)
//        }
//        alertController.addAction(okAction)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
//
//    }
    
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



