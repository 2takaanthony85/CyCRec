//
//  ViewController.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/02/25.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(UIFont.familyNames)
        //print(UIFont.fontNames(forFamilyName: "Font Awesome 5 Free"))
        //print(UIFont.fontNames(forFamilyName: "Font Awesome 5 Brands"))
        
        let cycleBarButton = UIBarButtonItem(customView: self.createButton())
        self.navigationItem.rightBarButtonItem = cycleBarButton
        
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
        print("tapped")
        let CycleVC = CycleViewController()
        self.present(CycleVC, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "sample"
        return cell
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

