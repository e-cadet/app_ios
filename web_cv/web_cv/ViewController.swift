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

//===================  extension check internet utilise protocol Utilities ==================
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

//================================== extension encoding data ===================================
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

//=============== extension String function emailV() pour valider email ========================
extension String {
    func emailV() -> Bool {
        
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
}


//========================= viewController ================================================
class ViewController: UIViewController{

   
    @IBOutlet weak var badgeLabel: UILabel!
    
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let xToken = UserDefaults.standard.object(forKey: "tokenValue")  as? String{
            
             token = xToken
            
            
        }
        
        let liens = "http://rouibah.fr/search/ApnsPHP/notification.php"
        
        let requestURL = NSURL(string: liens)
        let demande = "etat"
        let request = NSMutableURLRequest(url:requestURL! as URL )
        request.httpMethod = "POST"
        let postParameters = "demande="+demande+"&token="+token;
        
        print ("token value est : "+token)
        
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            
            
            request.httpBody = postParameters.data(using: String.Encoding.utf8)
            
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil{
                    print("lerreur est \(String(describing: error))")
                    return;
                }
                
                //parser la reponse
                do {
                    
                    
                    
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    
                    
                    
                    //parser json
                    if let parseJSON = myJSON {
                        
                        //creation string
                        var badge : String!
                        
                        //json reponse
                        badge = parseJSON["rep"] as! String!
                        
                        
                       //print("valeur badge : "+badge)
                        UserDefaults.standard.set(badge, forKey: "badgeValue")
                        
                        if badge == "0" {
                            self.badgeLabel.text = ""
                            self.badgeLabel.backgroundColor = UIColor(white: 1, alpha: 0)
                            
                        }
                        else {
                        
                            self.badgeLabel.text = ""+badge
                        }
                    }
                } catch {
                    print(error)
                }
                
            }
            //executer task
            task.resume()
            
        }

       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  

}

