//
//  PlayView.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/10.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit
import MapKit

class PlayView: UIView, MKMapViewDelegate {
    
    let mapView: MKMapView
    
    let screenSize = ScreenSize()
    var sizing = Sizing()
    //startButtonとpauseButtonの切り替えに使用するフラグ
    var buttonStatus: Bool
    
    let timeLabel: UILabel
    let distanceLabel: UILabel
    let realtimeSpeedlabel: UILabel
    let averageSpeedLabel: UILabel
    
    var polyLine: MKPolyline?
    
    //スタート
    private lazy var startButton: UIButton = {
        let startButton = UIButton()
        var buttonSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
        startButton.frame = CGRect(x: 0, y: Int(buttonSize.height + screenSize.header), width: Int(screenSize.width / 2), height: screenSize.labelHeight)
        startButton.backgroundColor = UIColor.green
        startButton.addTarget(CycleViewController(), action: #selector(CycleViewController.start), for: .touchUpInside)
        return startButton
    }()
    
    //ストップ
    private lazy var stopButton: UIButton = {
        let stopButton = UIButton()
        var buttonSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
        stopButton.frame = CGRect(x: Int(screenSize.width / 2), y: Int(buttonSize.height + screenSize.header), width: Int(screenSize.width / 2), height: screenSize.labelHeight)
        stopButton.backgroundColor = UIColor.MainColor()
        stopButton.addTarget(CycleViewController(), action: #selector(CycleViewController.stop), for: .touchUpInside)
        return stopButton
    }()
    
    //一時停止
    private lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        var buttonSize = sizing.mapViewSize(screenHeight: Int(screenSize.height))
        pauseButton.frame = CGRect(x: 0, y: Int(buttonSize.height + screenSize.header), width: Int(screenSize.width / 2), height: screenSize.labelHeight)
        pauseButton.backgroundColor = UIColor.orange
        pauseButton.addTarget(CycleViewController(), action: #selector(CycleViewController.pause), for: .touchUpInside)
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
        closeButton.addTarget(CycleViewController(), action: #selector(CycleViewController.close), for: .touchUpInside)
        return closeButton
    }()
    
    override init(frame: CGRect) {
        
        self.mapView = MKMapView(frame: CGRect(origin: .zero, size: frame.size))
        
        self.timeLabel = UILabel(frame: CGRect(x: screenSize.leftLabel_x, y: screenSize.topLabel_y, width: Int((screenSize.width - 6.0) / 2), height: screenSize.labelHeight))
        self.distanceLabel = UILabel(frame: CGRect(x: screenSize.leftLabel_x, y: screenSize.bottomLabel_y, width: Int((screenSize.width - 6.0) / 2), height: screenSize.labelHeight))
        self.realtimeSpeedlabel = UILabel(frame: CGRect(x: Int(screenSize.width / 2 + 1), y: screenSize.topLabel_y, width: Int((screenSize.width - 6.0) / 2), height: screenSize.labelHeight))
        self.averageSpeedLabel = UILabel(frame: CGRect(x: Int(screenSize.width / 2 + 1), y: screenSize.bottomLabel_y, width: Int((screenSize.width - 6.0) / 2), height: screenSize.labelHeight))
        
        buttonStatus = true
        
        super.init(frame: frame)
        
        self.mapView.delegate = self
        
        labelBackColorDesign()
        labelTextDesign()
        addComponent()
        
        //スタートする前はstopButtonは使用できない
        self.stopButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func labelBackColorDesign() {
        timeLabel.backgroundColor = UIColor.white
        distanceLabel.backgroundColor = UIColor.white
        realtimeSpeedlabel.backgroundColor = UIColor.white
        averageSpeedLabel.backgroundColor = UIColor.white
    }
    
    private func labelTextDesign() {
        timeLabel.text = "00:00:00"
        timeLabel.textAlignment = .right
        
        distanceLabel.text = "0.00 km"
        distanceLabel.textAlignment = .right
        
        realtimeSpeedlabel.text = "000.00 km/h"
        realtimeSpeedlabel.textAlignment = .right
        
        averageSpeedLabel.text = "000.00 km/h"
        averageSpeedLabel.textAlignment = .right
    }
    
    private func addComponent() {
        self.addSubview(self.mapView)
        self.addSubview(self.timeLabel)
        self.addSubview(self.distanceLabel)
        self.addSubview(self.realtimeSpeedlabel)
        self.addSubview(self.averageSpeedLabel)
        self.addSubview(self.startButton)
        self.addSubview(self.stopButton)
        self.addSubview(self.closeButton)
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
    
    //進んだ軌跡を生成
    func updatePolyLine(coordinates: [CLLocationCoordinate2D]) {

        if self.polyLine != nil {
            self.mapView.remove(self.polyLine!)
            self.polyLine = nil
        }
        
        self.polyLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        if let pl = polyLine {
            self.mapView.add(pl)
        }
    }
    
    //軌跡を地図上にレンダリング
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        polyLineRenderer.strokeColor = UIColor.red
        polyLineRenderer.alpha = 0.5
        polyLineRenderer.lineWidth = 5.0
        return polyLineRenderer
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
    
    func useEnabledStopButton() {
        self.stopButton.isEnabled = true
    }
    
    //瞬間最高時速の更新
    func updateRealTimeSpeedText(speed: Double) {
        realtimeSpeedlabel.text = String(format: "%.2f km/h", speed)
    }
    
    //平均時速の更新
    func updateAverageSpeedText(speed: Double) {
        averageSpeedLabel.text = String(format: "%.2f km/h", speed)
    }
    
    //距離の更新
    func updateDistanceText(distance: Double) {
        distanceLabel.text = String(format: "%.2f km", distance)
    }

}
