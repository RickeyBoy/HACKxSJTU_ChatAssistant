//
//  ChatAPI.swift
//  ChatAssistant
//
//  Created by Ruiji Wang on 16/08/2017.
//  Copyright © 2017 Rickey. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import ObjectMapper
//QUICK_LOGIN = 24

class ChatAPI: NSObject {
    static func fetchPowerfulData(text: String, type: String, completionHandler: @escaping () -> Void){
        let urlString = "https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/f111b7428d4a0f9d4d050e668e42edc63568c784c21a81c9251e143b2bfb36a0/powerful/powerful"
        let parameters = ["type":"","text":""]
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                completionHandler()
            case .failure( _):
                completionHandler()
            }
        }
    }
}


