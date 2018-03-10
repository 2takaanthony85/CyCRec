//
//  MeasureTime.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/10.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation

class MeasureTimer {
    
    var timer = Timer()
    //タイマーの値を生成するために使用するカウンタ
    var count: Int = 0
    //タイマーの値を表示するためのプロパティ
    var timeText: String
    
    //hour
    var hor: Int {
        get {
            return count / 3600
        }
    }
    
    //minute
    var min: Int {
        get {
            return count / 60
        }
    }
    
    //second
    var sec: Int {
        get {
            return count % 60
        }
    }
    
    init() {
        self.timeText = "00:00:00"
    }
    
    //タイマーの起動
    func startTimer() {
        //すでにタイマーが起動していないかの確認
        if self.timer.isValid == true {
        }
        else {
            //タイマーの生成
            self.timer = Timer.scheduledTimer(
                //実行メソッドを呼び出す間隔
                //1秒ごとに呼び出す
                timeInterval: 1,
                //自身で実行メソッドを呼び出す
                target: self,
                //実行メソッドの名前
                selector: #selector(updateTime),
                //実行メソッドの呼び出し時に受け渡す値
                userInfo: nil,
                //繰り返し実行するかどうか
                repeats: true)
        }
    }
    
    //タイマーを止める(Timerのインスタンスは破棄されてる)
    func stopTimer() {
        self.timer.invalidate()
    }
    
    //startTimer()で呼び出した実行メソッド
    //1秒ごとに以下の処理が実行される
    @objc func updateTime() {
        //1秒ごとにcountの値も+1する
        //タイマーの値を表示するために使用される
        count += 1
        //表示時のフォーマットの定義
        timeText = String(format:"%02d:%02d:%02d", hor, min, sec)
    }
}
