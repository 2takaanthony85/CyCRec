//
//  ViewController.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/02/25.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit
import RealmSwift

enum SortType: String {
    case id = "CycleID"
    case speed = "averageSpeed"
    case distance = "distance"
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, buttonTapped {
    
    @IBOutlet weak var tableView: UITableView!
    var sideView: SortSideView!
    let screenSize = ScreenSize()
    let realmData = CycleDataAccess()
    var type = SortType.id
    var dataObjects: [CycleDataObject] = []
    
    var rightEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        dataObjects = acquisitionData()
        tableView.reloadData()
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(UIFont.familyNames)
        //print(UIFont.fontNames(forFamilyName: "Font Awesome 5 Free"))
        //print(UIFont.fontNames(forFamilyName: "Font Awesome 5 Brands"))
        
        let cycleBarButton = UIBarButtonItem(customView: self.createButton())
        self.navigationItem.rightBarButtonItem = cycleBarButton
        
        tableView.dataSource = self
        tableView.delegate = self
        
        sideView = SortSideView(frame: CGRect(x: screenSize.width,
                                              y: 0,
                                              width: screenSize.width * 2,
                                              height: screenSize.height))
        sideView.delegate = self
        self.view.addSubview(sideView)
        
        rightEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(EdgePanGesture(_:)))
        rightEdgePanGesture.edges = .right
        self.view.addGestureRecognizer(rightEdgePanGesture)
        
    }
    
    func acquisitionData() -> [CycleDataObject] {
        switch type {
        case .id:
            let results = realmData.sortData(key: type.rawValue, ascend: true)
            return results
        case .distance:
            let results = realmData.sortData(key: type.rawValue, ascend: false)
            return results
        case .speed:
            let results = realmData.sortData(key: type.rawValue, ascend: false)
            return results
        }
    }
    
    //ナビゲーションボタンの生成
    func createButton() -> UIButton {
        let button = UIButton(type: .system)
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        button.titleLabel?.font = UIFont(name: "FontAwesome5FreeSolid", size: 30)
        button.titleLabel?.text = "bicycle"
        
        button.setTitle(button.titleLabel?.text, for: .normal)
        
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        
        return button
    }
    
    //ボタン押下で画面遷移
    @objc func play() {
        let CycleVC = CycleViewController()
        self.present(CycleVC, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch type {
        case .id:
            cell.textLabel?.text = dataObjects[indexPath.row].date + " の走行"
        case .distance:
            cell.textLabel?.text = String(dataObjects[indexPath.row].distance) + " km"
        case .speed:
            cell.textLabel?.text = String(dataObjects[indexPath.row].averageSpeed) + " km/h"
        }
        return cell
    }
    
    @objc func EdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        sideView.getEdgeGesture(sender: sender, parentVC: self)
    }
    
    func tappedButton(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case buttonType.date.rawValue:
            type = SortType.id
        case buttonType.totalDistance.rawValue:
            type = SortType.distance
        case buttonType.averageSpeed.rawValue:
            type = SortType.speed
        case .none:
            break
        case .some(_):
            break
        }
        dataObjects = acquisitionData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

