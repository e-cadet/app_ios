//
//  messageViewController.swift
//  Mysql_php
//
//  Created by rouibah on 13/09/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation

class messageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var messageTableView: UITableView!
     var items = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "http://rouibah.fr/search/rec_message.php")!
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url as URL) { (data, response, error) in
            
            
            let jsonData = try! JSONSerialization.jsonObject(with:data!, options: [])
            self.items = jsonData  as!  [[String : AnyObject]]
           
            DispatchQueue.main.async()
                {
                    self.messageTableView.reloadData()
            }
            
        }
        
        task.resume()
        
   
        
        
    }
    
    
    






 /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



   */
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell_message", for: indexPath) as! messageTableViewCell
    
    
    
    let item = items[indexPath.row]
    
    
    cell.nom_label.text = item["nom"] as? String
    cell.IP_label.text = item["ip"] as? String
    cell.email_label.text = item["email"] as? String
    cell.tel_label.text = item["tel"] as? String
    cell.date_label.text = item["jour"] as? String
    cell.heure_label.text = item["heure"] as? String
    cell.message_label.text = item["message"] as? String;
    
    return cell
    
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print ("selected rows is " , indexPath.row )
}


 
 
}
