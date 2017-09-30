//
//  contactViewController.swift
//  Mysql_php
//
//  Created by rouibah on 09/09/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit

class contactViewController: UIViewController {

    let URL_SAVE_TEAM = "http://rouibah.fr/search/contact.php"
    
    
    
    @IBOutlet weak var name_field: UITextField!
    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var tel_field: UITextField!
    @IBOutlet weak var message_field: UITextView!
    
    func alert_message ( the_msg:String){
        
        let alertController = UIAlertController(title: "Alert", message: the_msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func validation ( the_index:String ){
        if (the_index == "ok") {
            
            
            
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let stat_vc = storyBoard.instantiateViewController( withIdentifier: "succesViewController")
            
            self.present(stat_vc, animated: true, completion: nil)
            
            
            
        }
            
        else {
            
            self.alert_message (the_msg:"Désolé votre message n'a pas etait envoyé")
            
            
        }
        
    }
    
    @IBAction func envoyer_btn(_ sender: Any) {
        
        //created NSURL
        let requestURL = NSURL(string: URL_SAVE_TEAM)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url:requestURL! as URL )
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let name = name_field.text
        let email = email_field.text
        let tel = tel_field.text
        let message_t = message_field.text
        
        /*
        if (message_t?.characters.count)! > 300{
            self.alert_message (the_msg:"votre message depasse les 300 caracteres!!!!")
        }
 
        */
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "name="+name!+"&email="+email!+"&tel="+tel!+"&message_t="+message_t!;
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            //parsing the response
            do {
                //converting resonse to NSDictionary
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
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//=============================================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
