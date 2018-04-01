//
//  DataDetailViewController.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/04/01.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

class DataDetailViewController: UIViewController {
    
    var detailView: DataDetailView!
    var detailModel: CycleDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailView = DataDetailView(frame: CGRect(origin: .zero, size: self.view.frame.size), model: detailModel)
        self.view.addSubview(detailView)

    }

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
