//
//  MessageTableViewController.swift
//  ChatAssistant
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    //MARKS: Properties
    var chats = [Message]()
    let CELL_HEIGHT:CGFloat = 71
    let headerHeight:CGFloat = 40
    let searchHeight:CGFloat = 40
    var topHeight:CGFloat = 0
    var lastPosition:CGPoint = CGPoint.zero

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        self.lastPosition = CGPoint(x: 0, y: -topHeight)
        
        //MARKS: 设置导航行背景及字体颜色
        //WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        //加载测试用例
        loadSampleDatas(input: "App Name: Chat Assistant")
        loadSampleDatas(input: "talks more comfortable")
        loadSampleDatas(input: "Based on IBM APIs")
        loadSampleDatas(input: "Efficient & Powerful & Convenient")
        loadSampleDatas(input: "To make a better life")
        loadSampleDatas(input: "Let's enjoy")
    }
    
    func loadSampleDatas(input: String){
        let content = input
        let photo = UIImage(named: "parrot")!
        let chat = Message(title: "Hello IBM", content: content, photo: photo)!
        chats.append(chat)
    }
    
    
    // MARK: - Table view data source
    
    //MARKS: 设置每列高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Functions":
                if let dtvc = segue.destination as? PopoverViewController{
                    if let ppc = dtvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
