//
//  notificationViewController.swift
//  web_cv
//
//  Created by rouibah on 09/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation

class notificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var token = ""
    var badge = ""
    var items = [[String:AnyObject]]()
    
    var opQueue = OperationQueue()
    
    func alert_message ( the_title: String , the_msg:String){
        
        let alert = UIAlertController(title: the_title, message: the_msg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.opQueue.addOperation {
            
            OperationQueue.main.addOperation({
                self.present(alert, animated: true, completion: nil)
            })
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let badgeZero = "0"

        if let xToken = UserDefaults.standard.object(forKey: "tokenValue")  as? String{
            
            token = xToken
            
            
        }
        
        if let xBadge = UserDefaults.standard.object(forKey: "badgeValue")  as? String{
            
            badge = xBadge
            
            
        }
        
        let lien = "http://rouibah.fr/search/ApnsPHP/notification.php"
        let demande = "zero"
        let requestURL = NSURL(string: lien)
        let request = NSMutableURLRequest(url:requestURL! as URL )
        request.httpMethod = "POST"
        let postParameters = "demande="+demande+"&token="+token+"&badgeValue="+badge
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request as URLRequest) {data, response, error in
            
            
            let jsonData = try! JSONSerialization.jsonObject(with:data!, options:[])
            
            
            
            let json_decode = jsonData as! [[String:AnyObject]]
            self.items = json_decode
            
            //initialiser badge zero
           UserDefaults.standard.set(badgeZero, forKey: "badgeValue")
            
            DispatchQueue.main.async(){
                
                self.notificationTableView.reloadData()
                
            }
            
        }
        
        task.resume()

    
    
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(items.count)
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_not", for: indexPath) as! notificationViewCell
        
        
        
        var item = items[indexPath.row]
        
        let rep = item["rep"] as? String
        
        print(rep!)
        
        
        
        
        if rep! == "non"{
            
            self.alert_message (the_title: "Notification", the_msg:"Pas de notification!")
        
       }else {
       
        cell.title_label.text = item["title"] as? String
        cell.jour_label.text = item["jour"] as? String
        cell.notification_label.text = item["noti"] as? String
        
       }
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("selected rows is " , indexPath.row )
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
