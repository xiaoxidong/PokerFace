//
//  Network.swift
//  PokerFace
//
//  Created by xiaodong on 08/07/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import Alamofire

class Network: NSObject {
    
    let parameters: Parameters = [
        "foo": "bar",
        "baz": ["a", 1],
        "qux": [
            "x": 1,
            "y": 2,
            "z": 3
        ]
    ]

    
    
    func requestData(path: NSString, params: NSDictionary) {
        Alamofire.request("http://182.92.153.114:8080/app/project/get/project-b280375b-d270-4e25-a5bd-1ba8f6e667e3").responseJSON { (response) in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
        
        
        
        //请求数据
        
    }
    
}
