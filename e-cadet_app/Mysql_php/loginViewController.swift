//
//  loginViewController.swift
//  Mysql_php
//
//  Created by rouibah on 10/09/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
   
    
    
    let URL_SAVE_TEAM = "http://rouibah.fr/search/login.php"
   
    @IBOutlet weak var login_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    
    func alert_message ( the_msg:String){

        let alertController = UIAlertController(title: "Alert", message: the_msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    
    }
    
    func validation ( the_index:String ){
        if (the_index == "ok") {
            
            
            
            
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
                let stat_vc = storyBoard.instantiateViewController( withIdentifier: "statViewController")
            
                self.present(stat_vc, animated: true, completion: nil)
            
            
            
        }
            
        else {
            
            self.alert_message (the_msg:"mot de pass ou login incorect")
            
            
        }
        
    }
    
    
    func send_info (liens:String, login:String, pass:String){
        
       
        let requestURL = NSURL(string: liens)
        
        
        let request = NSMutableURLRequest(url:requestURL! as URL )
        
        
        request.httpMethod = "POST"
        
        
        let postParameters = "pseudo="+login+"&pass="+pass;
        
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
        
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
         
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("lerreur est \(String(describing: error))")
                return;
            }
            
            //parsing the response
            do {
                
               
                 
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                   
               
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["rep"] as! String?
                    
                    DispatchQueue.main.async {
                        self.validation (the_index: msg )
                        
                    }
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
            
        }
    }
    
    @IBAction func login_btn(_ sender: Any) {
        

        
        let  userEmail  = login_field.text
        let userPassword = password_field.text
        

        if (userEmail == "" || userPassword == ""){
            
            self.alert_message (the_msg:"Veillez remplire les champs")
        
        }   else {
                DispatchQueue.main.async(){
                    self.send_info(liens : self.URL_SAVE_TEAM, login: userEmail!, pass: userPassword!)
                }
            }
      
        
    }

}
