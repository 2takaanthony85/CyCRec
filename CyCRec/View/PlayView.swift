//
//  PlayView.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/10.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit
import MapKit

class PlayView: UIView {
    
    let mapView: MKMapView
    
    let screenSize = ScreenSize()
    var sizing = Sizing()
    //startButtonとpauseButtonの切り替えに使用するフラグ
    var buttonStatus: Bool
    
    //スタート
    private lazy var startButton: UIButton = {
        let startButton = UIButton()
        var buttonSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
        startButton.frame = CGRect(x: 0, y: Int(buttonSize.height + screenSize.header), width: Int(screenSize.width / 2), height: screenSize.labelHeight)
        startButton.backgroundColor = UIColor.green
        startButton.addTarget(PlayViewController(), action: #selector(PlayViewController.tappedStart), for: .touchUpInside)
        return startButton
    }()
    
    //ストップ
    private lazy var stopButton: UIButton = {
        let stopButton = UIButton()
        var buttonSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
        stopButton.frame = CGRect(x: Int(screenSize.width / 2), y: Int(buttonSize.height + screenSize.header), width: Int(screenSize.width / 2), height: screenSize.labelHeight)
        stopButton.backgroundColor = UIColor.MainColor()
        //stopButton.addTarget(PlayViewController(), action: #selector(PlayViewController.stop), for: .touchUpInside)
        return stopButton
    }()
    
    //一時停止
    private lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        var buttonSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
        pauseButton.frame = CGRect(x: 0, y: Int(buttonSize.height + screenSize.header), width: Int(screenSize.width / 2), height: screenSize.labelHeight)
        pauseButton.backgroundColor = UIColor.orange
        pauseButton.addTarget(PlayViewController(), action: #selector(PlayViewController.pause), for: .touchUpInside)
        return pauseButton
    }()
    
    //クローズ
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        var buttonSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
        closeButton.frame = CGRect(x: 0, y: Int(buttonSize.height + screenSize.header + screenSize.labelHeight), width: Int(screenSize.width), height: screenSize.labelHeight)
        closeButton.backgroundColor = UIColor.white
        closeButton.setTitle("close", for: .normal)
        closeButton.setTitleColor(UIColor.blue, for: .normal)
        //closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        return closeButton
    }()
    
    override init(frame: CGRect) {
        
        self.mapView = MKMapView(frame: CGRect(origin: .zero, size: frame.size))
        buttonStatus = true
        
        super.init(frame: frame)
        
        self.addSubview(self.mapView)
        self.addSubview(self.startButton)
        self.addSubview(self.stopButton)
        self.addSubview(self.closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //取得した位置情報を地図にピンとして貼り付ける
    func dropPin(latitude: Double, longitude: Double) {
        //経度・緯度の判定
        if latitude != 0 && longitude != 0 {
            //地図にピンを表示するためのオブジェクトを生成
            let annotation = MKPointAnnotation()
            //ピンの座標を位置情報の経度・緯度に設定
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            annotation.title = "start"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //地図の設定
    func regionDecision(region: MKCoordinateRegion) {
        //地図を表示する際のズームレベル、位置を決定
        self.mapView.setRegion(region, animated: true)
        //ユーザーの位置を追跡する　→　中心点の追跡　＋　ユーザーの向きの表示
        self.mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    }
    
    //ピンの見え方の設定
    //アノテーションビューを返す
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is MKUserLocation {
            return nil
        }
    
        let reuseId = "pinID"

        var pinView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //startButtonとpauseButtonを切り替える
    func switchButton() {
        if self.buttonStatus {
            self.addSubview(pauseButton)
            self.buttonStatus = false
        }
        else{
            self.addSubview(startButton)
            self.buttonStatus = true
        }
    }

}
