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
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
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
            }
            else if status == CLAuthorizationStatus.authorizedWhenInUse {
                //何もしない
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
        print(newLocation.coordinate.latitude)
        print(newLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    
    
}
