//
//  Alert.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/24.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import Foundation
import UIKit

protocol AlertDelegate {
    func ok(_ operation: Operation)
}

struct Alert {
    
    let alertContoroller: UIAlertController
    var delegate: AlertDelegate?
    
    init(pattern: Operation) {
        switch pattern {
        case .close:
            alertContoroller = UIAlertController(title: "close",
                                                 message: "計測したデータは保存されませんが、終了してもよろしいですか？",
                                                 preferredStyle: .alert)

        case .stop:
            alertContoroller = UIAlertController(title: "stop",
                                                 message: "計測を終了してデータを保存しますか？",
                                                 preferredStyle: .alert)
        }
    }
    
    func ShowAction(_ operation: Operation) {
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.delegate?.ok(operation)
        }
        alertContoroller.addAction(okAction)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertContoroller.addAction(cancel)
    }
    

}
