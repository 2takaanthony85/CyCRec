//
//  ViewController.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/02/25.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

enum SortType {
    case id
    case speed
    case distance
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let data = realmDataAccess()
    var type = SortType.id
    var dataObjects: [CycleDataObject] = []
    
    var bottomPanGesture: UIScreenEdgePanGestureRecognizer!
    
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
        
        bottomPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(EdgePanGesture(_:)))
        bottomPanGesture.edges = .right
        self.view.addGestureRecognizer(bottomPanGesture)
    }
    
    func acquisitionData() -> [CycleDataObject] {
        switch type {
        case .id:
            let results = data.sortData()
            return results
        case .distance:
            let results = data.sortDistance()
            return results
        case .speed:
            let results = data.sortSpeed()
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
            cell.textLabel?.text = String(dataObjects[indexPath.row].averageSpeed) + "km/h"
        }
        return cell
    }
    
    @objc func EdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        print("swipe")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

