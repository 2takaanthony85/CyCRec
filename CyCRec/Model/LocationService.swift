//
//  LocationService.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/17.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager
    //フィルターをかけて取得した位置情報
    var locationDataArray: [CLLocation]
    var userFilter: Bool
    
    override init() {
        
        locationManager = CLLocationManager()
        
        //位置情報取得の精度
        //精度高めの設定
        //5m単位で位置情報を取得するように設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        
        //バックグラウンド時でも位置情報取得を可能にする
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = false
        //locationManager.pausesLocationUpdatesAutomatically = true
        //locationManager.activityType = .fitness
        
        locationDataArray = []
        userFilter = true
        
        super.init()
        
        locationManager.delegate = self
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //デバイスの位置情報サービスがONかOFFか
        if CLLocationManager.locationServicesEnabled(){
            //アプリケーションの位置情報サービスの設定
            if status == CLAuthorizationStatus.notDetermined {
                //フォアグラウンドからの起動を許可
                locationManager.requestWhenInUseAuthorization()
                //バックグラウンド時でも位置情報取得を可能にする
                //capabilitiesのbackground modeをonにして
                //location updateにチェックを入れないとエラーで落ちる
                locationManager.allowsBackgroundLocationUpdates = true
                //
                locationManager.pausesLocationUpdatesAutomatically = true
                locationManager.activityType = .fitness
            }
            else if status == CLAuthorizationStatus.authorizedWhenInUse {
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.pausesLocationUpdatesAutomatically = true
                locationManager.activityType = .fitness
            }
        }
        else{
            //alertの表示
            //位置情報サービスをONにさせる
        }
    }
    
    //位置情報の取得開始
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else {
            return
        }
        //指定された座標値が有効かどうか判定
        if !CLLocationCoordinate2DIsValid(newLocation.coordinate) {
            return
        }
        
        var locationAdded: Bool
        if userFilter {
            locationAdded = filterLocation(newLocation)
        }
        else {
            locationDataArray.append(newLocation)
            locationAdded = true
        }
        
        if locationAdded {
            updateNewLocation(newLocation: newLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    //取得した位置情報をフィルターにかける
    func filterLocation(_ location: CLLocation) -> Bool {
        let age = -location.timestamp.timeIntervalSinceNow
        
        if age > 10 {
            return false
        }
        
        if location.horizontalAccuracy < 0 {
            return false
        }
        
        if location.horizontalAccuracy > 100 {
            return false
        }
        
        locationDataArray.append(location)
        
        return true
    }
    
    func updateNewLocation(newLocation: CLLocation) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdateLocation"), object: nil, userInfo: ["location": newLocation])
    }
    
    //
    func coordinate2DArrayAppend(locations: [CLLocation], updateFunc: ([CLLocationCoordinate2D]) -> Void) {
        var coordinateArray = [CLLocationCoordinate2D]()
        for location in locations {
            coordinateArray.append(location.coordinate)
        }
        updateFunc(coordinateArray)
    }
    
}
