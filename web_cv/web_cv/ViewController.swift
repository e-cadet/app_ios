//
//  ViewController.swift
//  web_cv
//
//  Created by rouibah on 01/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration


protocol Utilities {
}

extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            
            
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            
            
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}


class ViewController: UIViewController{

    
    //let delegate = AppDelegate.getDelegate()
    //application.applicationIconBadgeNumber!
     //var appDel = UIApplication.shared.delegate as! AppDelegate
     //var variable = self.appDel.myVariable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  

}

