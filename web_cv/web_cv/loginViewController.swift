//
//  loginViewController.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation


class loginViewController: UIViewController {
    
   
    
    
    let URL = "http://rouibah.fr/search/web.php"
    
    @IBOutlet weak var login_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    
    

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
    
    func validation ( the_index:String ){
        if (the_index == "ok") {
            
            
            
            
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
                let stat_vc = storyBoard.instantiateViewController( withIdentifier: "messageViewController")
            
                self.present(stat_vc, animated: true, completion: nil)
            
            
            
        }
            
        else {
            
            self.alert_message (the_title : "Alert", the_msg:"mot de pass ou login incorect")
            
            
        }
        
    }
    
    
    func send_info (liens:String, login:String, pass:String){
        
       
        let requestURL = NSURL(string: liens)
        let demande = "login"
        let request = NSMutableURLRequest(url:requestURL! as URL )
        request.httpMethod = "POST"
        let postParameters = "demande="+demande+"&pseudo="+login+"&pass="+pass;
        
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
                    var msg : String!
                    
                    //json response
                    msg = parseJSON["rep"] as! String?
                    
                    DispatchQueue.main.async {
                        self.validation (the_index: msg )
                        
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
    
    
    
    
    @IBAction func login_btn(_ sender: Any) {
        
        let  userEmail  = login_field.text
        let userPassword = password_field.text
        

        if (userEmail == "" || userPassword == ""){
            
            self.alert_message (the_title : "Alert", the_msg:"Veillez remplire les champs")
        
        }   else {
                DispatchQueue.main.async(){
                    self.send_info(liens : self.URL, login: userEmail!, pass: userPassword!)
                }
            }
      
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let check_internet = (currentReachabilityStatus != .notReachable)
        
        if check_internet == false {
            
            self.alert_message (the_title: "Erreur Connexion", the_msg:"Cette page exige une connexion internet")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//============================================= fin de code ==============================================
    

}
