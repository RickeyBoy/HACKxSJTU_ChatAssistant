//
//  Message.swift
//  ChatAssistant
//
//  Created by apple on 05/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import UIKit

class Message {
    
    //MARK: Properties
    var title:String
    var content:String
    var photo:UIImage?
    
    init?(title:String,content:String,photo:UIImage?){
        self.title = title
        self.content = content
        self.photo = photo

        if(title.isEmpty || content.isEmpty) {
            return nil
        }
    }
}
