//
//  blogViewController.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation


    
   


class blogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var badgeLabel: UILabel!
    
    var badge = ""
    
     @IBOutlet weak var blogTableView: UITableView!
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
        
        if let xBadge = UserDefaults.standard.object(forKey: "badgeValue")  as? String{
            
            badge = xBadge
        }
        
        if badge == "0" {
            self.badgeLabel.text = ""
            self.badgeLabel.backgroundColor = UIColor(white: 1, alpha: 0)
            
            print("badge blog = "+badge)
            
        }
        else {
            
            self.badgeLabel.text = ""+badge
            print("badge blog = "+badge)
        }
        
     
        
        let check_internet = (currentReachabilityStatus != .notReachable)
        if check_internet == false {
            
            self.alert_message (the_title: "Erreur Connexion", the_msg:"Cette page exige une connexion internet")
            
        }else {
        let lien = "http://rouibah.fr/search/web.php"
        let demande = "blog"
        let requestURL = NSURL(string: lien)
        let request = NSMutableURLRequest(url:requestURL! as URL )
        request.httpMethod = "POST"
        let postParameters = "demande="+demande
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request as URLRequest) {data, response, error in
            
            
            let jsonData = try! JSONSerialization.jsonObject(with:data!, options:[])
            
            
            
            
            self.items = jsonData as! [[String:AnyObject]]
            
            
            DispatchQueue.main.async(){
                
                    self.blogTableView.reloadData()
            }
            
            
        }
        
        task.resume()
            
        }
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! blogViewCell
       
            
        let item = items[indexPath.row]
        cell.title.text = item["title"] as? String
        cell.desc.text = item["descr"] as? String
        cell.jour.text = item["jour"] as? String
        
      cell.indicateur.startAnimating();
        
        
        DispatchQueue.main.async {
        // initialisation url
        let url_img : String = "http://rouibah.fr/search/img/"
        let ext : String = ".jpg"
        let imageUrlString = "\(url_img)" + "\( item["image"]!)" + "\(ext)"
        let imageUrl:URL = URL(string: imageUrlString )!
        
        // dispatching globale
        DispatchQueue.global(qos: .userInitiated).async {
            
           
            //initilisation image UIImage
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            let imageView = UIImageView()
            imageView.center = self.view.center
            
                // image in cell
                let image = UIImage(data: imageData as Data)
                imageView.image = image
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                cell.imgView.image = image
            
                //stop indicateur animation
                cell.indicateur.stopAnimating()
            }
            
        }
        
            
       
        return cell
        
    }
    
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("selected rows is " , indexPath.row )
    }
    
    
    
}




//============================================= fin de code ==============================================

