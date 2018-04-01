//
//  SortSideView.swift
//  CyCRec
//
//  Created by 吉川昂広 on 2018/03/31.
//  Copyright © 2018年 takahiro yoshikawa. All rights reserved.
//

import UIKit

enum buttonType: String {
    case date = "calendar-alt"
    case totalDistance = "road"
    case averageSpeed = "clock"
    
    static let buttonTypes: [buttonType] = [.date, .totalDistance, .averageSpeed]
}

protocol buttonTapped {
    func tappedButton(_ sender: UIButton)
}

class SortSideView: UIView {
    
    var panGesture: UIPanGestureRecognizer!
    var delegate: buttonTapped?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
        self.alpha = 0.8
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.getPanGesture(_:)))
        self.addGestureRecognizer(panGesture)
        
        var counter = 0
        for type in buttonType.buttonTypes {
            let button = UIButton(frame: CGRect(x: 10, y: 80 + 110 * counter, width: 90, height: 90))
            button.backgroundColor = UIColor.yellow
            button.layer.cornerRadius = 45
            button.titleLabel?.font = UIFont(name: "FontAwesome5FreeSolid", size: 60)
            button.titleLabel?.text = type.rawValue
            button.setTitle(button.titleLabel?.text, for: .normal)
            button.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
            self.addSubview(button)
            counter += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onButtonTapped(_ sender: UIButton) {
        self.delegate?.tappedButton(sender)
    }
    
    func getEdgeGesture(sender: UIScreenEdgePanGestureRecognizer, parentVC: UIViewController) {
        let move: CGPoint = sender.translation(in: parentVC.view)
        self.frame.origin.x += move.x
        //self.layoutIfNeeded()
        
        if sender.state == UIGestureRecognizerState.ended {
            if self.frame.origin.x < (UIScreen.main.bounds.width - parentVC.view.frame.size.width / 4) {
                UIView.animate(withDuration: 0.5,
                               animations: {
                                self.frame.origin.x = UIScreen.main.bounds.width * 2/3
                },
                               completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.5,
                               animations: {
                                self.frame.origin.x = UIScreen.main.bounds.width
                },
                               completion: nil)
            }
        }
        sender.setTranslation(CGPoint.zero, in: parentVC.view)
    }
    
    @objc func getPanGesture(_ sender: UIPanGestureRecognizer) {
        let move = sender.translation(in: self)
        
        self.frame.origin.x += move.x
        
        if sender.state == UIGestureRecognizerState.changed {
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.frame.origin.x = UIScreen.main.bounds.width
            },
                           completion: nil)
        }
        sender.setTranslation(CGPoint.zero, in: self)
    }
    
    func closeSelfView() {
        self.frame.origin.x = UIScreen.main.bounds.width
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
