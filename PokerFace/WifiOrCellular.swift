//
//  Net.swift
//  PokerFace
//
//  Created by xiaodong on 02/05/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import ReachabilitySwift

class WifiOrCellular: NSObject {
    static let shareSingleOne = WifiOrCellular()
    
    class func wifiOrCellular() {
        //declare this property where it won't go out of scope relative to your listener
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "无网络连接",
                                                subtitle: "似乎没有网络连接，请检查",
                                                style: .warning,
                                                colors: CustomBannerColors())
                
                banner.show()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
}
