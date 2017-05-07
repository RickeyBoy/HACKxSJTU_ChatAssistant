//
//  gestureView.swift
//  ChatAssistant
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import UIKit

class gestureView: UIView {

    func gestureChangeButton(gesture:UILongPressGestureRecognizer){
        if gesture.state == UIGestureRecognizerState.began{
            //创建警告
            print("x")
            ChatViewController().changeButtonStyle(s: "G")
        }
    }

}
