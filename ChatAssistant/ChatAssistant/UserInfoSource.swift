//
//  UserInfoSource.swift
//  ChatAssistant
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import Foundation

/*
 用户信息类
 */
class UserInfo:NSObject
{
    var username:String = ""
    var avatar:String = ""
    
    init(name:String, logo:String)
    {
        self.username = name
        self.avatar = logo
    }
}
