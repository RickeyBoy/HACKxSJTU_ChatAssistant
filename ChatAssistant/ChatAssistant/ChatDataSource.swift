//
//  ChatDataSource.swift
//  ChatAssistant
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import Foundation

/*
 数据提供协议
 */
protocol ChatDataSource
{
    /*返回对话记录中的全部行数*/
    func rowsForChatTable( _ tableView:TableView) -> Int
    /*返回某一行的内容*/
    func chatTableView(_ tableView:TableView, dataForRow:Int)-> MessageItem
}

