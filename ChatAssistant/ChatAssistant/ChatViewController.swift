//
//  ChatViewController.swift
//  ChatAssistant
//
//  Created by apple on 06/05/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import UIKit
import Foundation

class ChatViewController:  UIViewController, ChatDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var resultButton: UIBarButtonItem!
    
    func changeButtonStyle(s: String){
        resultButton.title = s
    }
    
    @IBOutlet weak var gestureView: UIView! {
        didSet{
            gestureView.addGestureRecognizer(UILongPressGestureRecognizer(target: gestureView, action: Selector(("gestureChangeButton:"))))
        }
    }
    @IBAction func sendButton(_ sender: UIButton) {
        sendMessage(text: "")
    }
    
    var offset:Int = 53
    var textTemp = ""
    var newInput = ""
    var Chats:NSMutableArray!
    var tableView:TableView!
    var me:UserInfo!
    var you:UserInfo!
    var txtMsg:UITextField!
    var sendBackView = UIView(frame:CGRect(x: 0,y: 1000 - 56 ,width: 300 ,height: 56))
    var txtEmotion:String = ""{
        didSet{
            switch txtEmotion {
            case "anger": txtColor = UIColor.red
                break
            case "disgust" : txtColor = UIColor.green
                break
            case "fear" : txtColor = UIColor.purple
                break
            case "joy" : txtColor = UIColor.init(red: 255, green: 204, blue: 0, alpha: 1)
                break
            case "sadness" : txtColor = UIColor.blue
                break
            default:
                break
            }
        }
    }
    var txtColor:UIColor = UIColor.lightGray {
        didSet{
            txtMsg.removeFromSuperview()
            setupSendBack()
        }
    }
    
    var v = "" {
        didSet{
            offset += 1
            print(v)
            sendMessage(text: v)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ChatView"
        
        setupChatTable()
        setupSendBack()
        
        let firstInput = "IBM is the greatest company in the world! Coding with OpenWhisk makes me excited."
        
        textTemp = ""
        fetchData(input: firstInput, Type: "Entities")
        fetchData(input: firstInput, Type: "Emotion")
        
        //runloop轮询接受消息
        DispatchQueue.global().async {
            // 非主线程不能使用 Timer.scheduledTimer进行初始化
            let timer = Timer(timeInterval: 3, repeats: true, block: { (timer) in
                self.fetchMessage(offset: "\(self.offset)")
            })
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        
        //开启键盘监听
        //NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //deinit {
        //移除键盘通知
        //NotificationCenter.default.removeObserver(self)
    //}
    
    func setupSendBack() {
        //创建消息框
        let screenWidth = UIScreen.main.bounds.width
        sendBackView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height - 56,width: screenWidth,height: 56))
        
        sendBackView.backgroundColor=UIColor.white
        sendBackView.alpha=0.5
        
        txtMsg = UITextField(frame:CGRect(x: 45,y: 10,width: screenWidth - 200,height: 30))
        txtMsg.backgroundColor = txtColor
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendBackView.addSubview(txtMsg)
        self.view.addSubview(sendBackView)
    }
    
    func setupSendBackTop(keyBoardHeight: CGFloat){
        let screenWidth = UIScreen.main.bounds.width
        sendBackView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height - 56 + keyBoardHeight ,width: screenWidth,height: 56))
        
        sendBackView.backgroundColor=UIColor.white
        sendBackView.alpha=0.5
        
        txtMsg = UITextField(frame:CGRect(x: 45,y: 10,width: screenWidth - 200,height: 30))
        txtMsg.backgroundColor = txtColor
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendBackView.addSubview(txtMsg)
        self.view.addSubview(sendBackView)
    }
    
    func fetchMessage(offset: String) -> Void
    {
        //获取消息
        let url = "https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/9efda2b6ba2be2eac74b3bf7f8bc37f9cfac1505ad6789833f87e4ae289f28de/pull_api/pull_action?offset="+offset
        DispatchQueue.global().async{ ()-> Void in
            let parseData = self.parseJSON(inputData: self.getJSON(urlToRequest: url))
            //print(parseData)
            if parseData.count != 0 {
                if parseData["-1"] == nil{
                    for (_,value) in parseData{
                        //print("\(key):\(value)")
                        self.v = "\(value)"
                    }
                    /*
                    //sort
                    var a = [Int]()
                    var b = [String]()
                    var t:NSNumber
                    for (key,value) in parseData{
                        t = (key as! NSNumber)
                        a.append(t.intValue)
                        b.append(value as? String ?? "")
                    }
                    a.sort(by: <)
                    for ele in a{
                        print("\(ele):\(parseData[ele])")
                    }
                    */
                }
            }
        }
    }
    
    func fetchData(input: String, Type:String) -> Void {
        //解析JSON信息
        let url = "https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/6d42906167d017b9394c9de3b84bcdaaed75ba5bf40ad8db419de6e67a04271a/powerful/powerful"
        newInput = input.replacingOccurrences(of: " ", with: "+")
        let actualResult = url+"?text=%22"+newInput+"%22&type="+Type
        
        //多线程处理
        DispatchQueue.global().async{ ()-> Void in
            let parseData = self.parseJSON(inputData: self.getJSON(urlToRequest: actualResult))
            print(parseData)
            switch Type {
            case "Entities":
                for (key, value) in parseData{
                    if key as? String != "NULL"{
                        self.textTemp = self.textTemp+"\(key):\n\t\(value)\n"
                    }
                }
                break
            case "Emotion":
                var maxkey = ""
                var maxvalue:Double = 0.0
                for (key, value) in parseData{
                    if (value as! Double)>maxvalue{
                        maxvalue = value as! Double
                        maxkey = key as! String
                    }
                }
                self.textTemp = self.textTemp + "Emotion: " + maxkey + "\n"
                DispatchQueue.main.async{
                    //回到主线程
                    self.txtEmotion = maxkey
                }
                break
            default:
                break
            }
        }
    }
    
    //解析JSON信息
    func getJSON(urlToRequest:String) -> NSData
    {
        return NSData(contentsOf: NSURL(string: urlToRequest)! as URL)!
    }
    func parseJSON(inputData:NSData) -> NSDictionary{
        let dictData = (try! JSONSerialization.jsonObject(with: inputData as Data, options: .mutableContainers)) as! NSDictionary
        return dictData
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage(text: "")
        return true
    }
    
    func sendMessage(text: String)
    {
        if text == "" {
            if let sender = txtMsg{
                let thisChat =  MessageItem(body:sender.text! as NSString, user:me, date:Date(), mtype:ChatType.mine)
                let thatChat =  MessageItem(body:"\(sender.text!)" as NSString, user:you, date:Date(), mtype:ChatType.someone)
                newInput = sender.text!
                
                Chats.add(thisChat)
                Chats.add(thatChat)
                self.tableView.chatDataSource = self
                self.tableView.reloadData()
                
                sender.resignFirstResponder()
                sender.text = ""
                
                textTemp = ""
                fetchData(input: newInput, Type: "Entities")
                fetchData(input: newInput, Type: "Emotion")
            }
        }
        else {
            let tx: NSString = NSString(cString: text.cString(using: String.Encoding.utf8)!,encoding: String.Encoding.utf8.rawValue)!
            let thisChat =  MessageItem(body: tx as NSString, user:me, date:Date(), mtype:ChatType.mine)
            let thatChat =  MessageItem(body:"\(tx)" as NSString, user:you, date:Date(), mtype:ChatType.someone)
            newInput = text
            
            Chats.add(thisChat)
            Chats.add(thatChat)
            self.tableView.chatDataSource = self
            self.tableView.reloadData()
            
            textTemp = ""
            fetchData(input: newInput, Type: "Entities")
            fetchData(input: newInput, Type: "Emotion")
    }
}
    
    func setupChatTable()
    {
        self.tableView = TableView(frame:CGRect(x: 0, y: 80, width: self.view.frame.size.width, height: self.view.frame.size.height - 76), style: .plain)
        
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name:"Rickey" ,logo:("parrot"))
        you  = UserInfo(name:"Bluemix", logo:("Bluemix"))
        
        let first =  MessageItem(body:"HACKxSJTU =.= Definitely crazy", user:me,  date:Date(timeIntervalSinceNow:0), mtype:.mine)
        
        let zero =  MessageItem(body:"IBM is the greatest company in the world! Coding with OpenWhisk makes me excited.", user:you,  date:Date(timeIntervalSinceNow:0), mtype:.someone)
        
        Chats = NSMutableArray()
        Chats.addObjects(from: [first, zero])
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
    }
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
    
    /*
    //键盘
    func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        let changeY = kbRect.origin.y - self.view.frame.size.height
        
        print(changeY)
        sendBackView.removeFromSuperview()
        setupSendBackTop(keyBoardHeight: changeY)
        }
    func keyBoardWillHide(_ notification: Notification){
        sendBackView.removeFromSuperview()
        setupSendBack()
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Search":
                if let dtvc = segue.destination as? BluemixResultViewController{
                    dtvc.text = textTemp
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



