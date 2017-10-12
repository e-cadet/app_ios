//
//  messageViewController.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}



class messageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var badgeLabel: UILabel!
    
   
    
    var items = [[String : AnyObject]]()
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
        
        
        
        
        let check_internet = (currentReachabilityStatus != .notReachable)
        if check_internet == false {
            
            self.alert_message (the_title: "Erreur Connexion", the_msg:"Cette page exige une connexion internet")
            
        }else {
        
       
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
                    
                    
                    
                            let json_decode = jsonData as! [[String:AnyObject]]
                            self.items = json_decode
                        
                            DispatchQueue.main.async(){
                                
                            self.messageTableView.reloadData()
                    
                            }
                    
                    }
                
                task.resume()
       
        }
    }
    

    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
    
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "message_cell", for: indexPath) as! messageTableViewCell
    
    
    
    var item = items[indexPath.row]
    let message = item["message"] as? String
    let message_dec = String(htmlEncodedString: message!)
    
    cell.nom_label.text = item["nom"] as? String
    cell.IP_label.text = item["ip"] as? String
    cell.email_label.text = item["email"] as? String
    cell.tel_label.text = item["tel"] as? String
    cell.date_label.text = item["jour"] as? String
    cell.heure_label.text = item["heure"] as? String
    cell.message_label.text = message_dec
    
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
