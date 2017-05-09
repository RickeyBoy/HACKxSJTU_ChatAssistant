//
//  MessageItem.swift
//  ChatAssistant
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import UIKit

//消息类型
enum ChatType {
    case mine
    case someone
}

class MessageItem {
    //用户信息
    var user:UserInfo
    //消息时间
    var date:Date
    //消息类型
    var mtype:ChatType
    //内容视图，标签或者图片
    var view:UIView
    //边距
    var insets:UIEdgeInsets
    
    //设置我的文本消息边距
    class func getTextInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:10, bottom:9, right:17)
    }
    
    //设置他人的文本消息边距
    class func getTextInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:15, bottom:9, right:10)
    }
    
    //设置我的图片消息边距
    class func getImageInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:10, bottom:9, right:17)
    }
    
    //设置他人的图片消息边距
    class func getImageInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets(top:9, left:15, bottom:9, right:10)
    }
    
    //构造文本消息体
    convenience init(body:NSString, user:UserInfo, date:Date, mtype:ChatType) {
        let font =  UIFont.boldSystemFont(ofSize: 12)
        
        let width =  225, height = 10000.0
        
        let atts =  [NSFontAttributeName: font]
        
        let size =  body.boundingRect(with:
            CGSize(width: CGFloat(width), height: CGFloat(height)),
                                      options: .usesLineFragmentOrigin, attributes:atts, context:nil)
        
        let label =  UILabel(frame:CGRect(x: 0, y: 0, width: size.size.width,
                                          height: size.size.height))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = (body.length != 0 ? body as String : "")
        label.font = font
        label.backgroundColor = UIColor.clear
        
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ?
            MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:label, insets:insets)
    }
    
    //可以传入更多的自定义视图
    init(user:UserInfo, date:Date, mtype:ChatType, view:UIView, insets:UIEdgeInsets) {
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
    }
    
    //构造图片消息体
    convenience init(image:UIImage, user:UserInfo,  date:Date, mtype:ChatType) {
        var size = image.size
        //等比缩放
        if (size.width > 220) {
            size.height /= (size.width / 220);
            size.width = 220;
        }
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: size.width,
                                                 height: size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ?
            MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user:user,  date:date, mtype:mtype, view:imageView, insets:insets)
    }    
}
