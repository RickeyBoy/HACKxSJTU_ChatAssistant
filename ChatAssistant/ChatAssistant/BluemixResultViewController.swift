//
//  BluemixResultViewController.swift
//  ChatAssistant
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import UIKit

class BluemixResultViewController: UIViewController {

    var text = ""
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        textView.text = text
    }
    
    override var preferredContentSize: CGSize {
        get {
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }else{
                return super.preferredContentSize
            }
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
}
