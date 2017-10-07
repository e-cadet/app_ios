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

   
   
   
   
    
    
//========================================================================
    
    
    
     @IBOutlet weak var blogTableView: UITableView!
    var items = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            print (jsonData)
            
            DispatchQueue.main.async(){
                
                    self.blogTableView.reloadData()
            }
            
            
        }
        
        task.resume()
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
        let url_img : String = "http://rouibah.fr/search/img_red/"
        let ext : String = ".jpg"
        let imageUrlString = "\(url_img)" + "\( item["image"]!)" + "\(ext)"
        let imageUrl:URL = URL(string: imageUrlString )!
        
        // dispatching globale
        DispatchQueue.global(qos: .userInitiated).async {
            
           
            //initilisation image UIImage
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            let imageView = UIImageView(frame: CGRect(x:0, y:0, width:200, height:200))
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

