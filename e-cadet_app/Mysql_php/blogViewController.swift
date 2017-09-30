//
//  blogViewController.swift
//  Mysql_php
//
//  Created by rouibah on 11/09/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit

class blogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

   
   
   
    
    
//========================================================================
    
    
     @IBOutlet weak var myTableView: UITableView!
    var items = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://rouibah.fr/search/rec_blog.php")!
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: url as URL) { (data, response, error) in
            
            // JSON parsen und Ergebnis in eine Liste von assoziativen Arrays wandeln
            let jsonData = try! JSONSerialization.jsonObject(with: data!, options: [])
            self.items = jsonData as! [[String:AnyObject]]
            
            // UI-Darstellung aktualisieren
            DispatchQueue.main.async()
            {
                self.myTableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTableViewCell
       
            
        let item = items[indexPath.row]
        cell.title.text = item["title"] as? String
        cell.desc.text = item["descr"] as? String
        cell.jour.text = item["jour"] as? String
        
      cell.indicateur.startAnimating();
        
        let url_img : String = "http://rouibah.fr/search/img/"
        let ext : String = ".jpg"
       let imageUrlString = "\(url_img)" + "\( item["image"]!)" + "\(ext)"
        print(imageUrlString)
        let imageUrl:URL = URL(string: imageUrlString )!
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
           cell.indicateur.stopAnimating()
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            let imageView = UIImageView(frame: CGRect(x:0, y:0, width:200, height:200))
            imageView.center = self.view.center
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                imageView.image = image
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                cell.imgView.image = image
                
                
            }
        }
        
            
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("selected rows is " , indexPath.row )
    }
}
