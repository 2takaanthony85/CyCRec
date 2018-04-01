//
//  ChildView.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/04/01.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

protocol movement {
    func rightMove()
}

class ChildView: UIView {
    
    var delegate: movement?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        label.font = UIFont(name: "FontAwesome5FreeSolid", size: 45)
        label.text = "bicycle"
        label.textColor = UIColor.tableViewTextColor()
        label.textAlignment = .center
        self.addSubview(label)
        
        //animationSelfView()
    }
    
    func animationSelfView() {
        self.delegate?.rightMove()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
