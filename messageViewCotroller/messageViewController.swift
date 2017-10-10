//
//  messageViewController.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation



class messageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTableView: UITableView!
    
    var items = [[String : AnyObject]]()
    
        var itom = NSString()
      
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       
                let lien = "http://rouibah.fr/search/web.php"
                let demande = "message"
                let requestURL = NSURL(string: lien)
                let request = NSMutableURLRequest(url:requestURL! as URL )
                request.httpMethod = "POST"
                let postParameters = "demande="+demande
                request.httpBody = postParameters.data(using: String.Encoding.utf8)
                let urlSession = URLSession.shared

                let task = urlSession.dataTask(with: request as URLRequest) {data, response, error in
                    
                    
                            let jsonData = try! JSONSerialization.jsonObject(with:data!, options:[])
                    
                    
                    
                    
                            self.items = jsonData as! [[String:AnyObject]]
                            print (jsonData)
                            self.messageTableView.reloadData()
                    
                    
                    
                    }
                
                task.resume()
       
        
    }
    

    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
    
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "message_cell", for: indexPath) as! messageTableViewCell
    
    
    
    var item = items[indexPath.row]
    //var item = items
    
    cell.nom_label.text = item["nom"] as? String
    cell.IP_label.text = item["ip"] as? String
    cell.email_label.text = item["email"] as? String
    cell.tel_label.text = item["tel"] as? String
    cell.date_label.text = item["jour"] as? String
    cell.heure_label.text = item["heure"] as? String
    cell.message_label.text = item["message"] as? String
    
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
