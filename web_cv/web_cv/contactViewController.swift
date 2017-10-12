//
//  contactViewController.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation




class contactViewController: UIViewController, UITextFieldDelegate {

    let URL = "http://rouibah.fr/search/web.php"
    
    var badge = ""
    
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var name_field: UITextField!
    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var tel_field: UITextField!
    @IBOutlet weak var message_field: UITextView!
    
    
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
            
            let stat_vc = storyBoard.instantiateViewController( withIdentifier: "succesViewController")
            
            self.present(stat_vc, animated: true, completion: nil)
            
            
            
        }
            
        else {
            
            self.alert_message (the_title: "Alert", the_msg:"Désolé votre message n'a pas etait envoyé")
            
            
        }
        
    }
    
    
    @IBAction func envoyer_btn(_ sender: Any) {
        
        //creation NSURL
        let requestURL = NSURL(string: URL)
        
        //creation NSMutableURLRequest
        let request = NSMutableURLRequest(url:requestURL! as URL )
        
        //request method post
        request.httpMethod = "POST"
        
        //var depuis text fields
        let name = name_field.text
        let email = email_field.text
        let tel = tel_field.text
        let message_t = message_field.text
        
       
        if (message_t?.characters.count)! > 300{
            self.alert_message (the_title: "Alert", the_msg:"votre message depasse les 300 caracteres!!!!")
        }
 
        if ((name?.isEmpty)! || (email?.isEmpty)! || (tel?.isEmpty)! || (message_t?.isEmpty)!){
            
            
            self.alert_message (the_title: "Alert", the_msg:"veilliez renseigner tout les champs")
            
        }
        else if (email?.emailV())! {
            
        
                //creation post parametre
            
                let demande = "insertContact"
                let postParameters = "demande="+demande+"&nom="+name!+"&email="+email!+"&tel="+tel!+"&message="+message_t!;
        
                //ajouter parametres pour request body
                request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
                //creation task et envoyer en post request
                let task = URLSession.shared.dataTask(with: request as URLRequest){
                        data, response, error in
            
                        if error != nil{
                                print("error is \(String(describing: error))")
                                return;
                        }
            
                        //parser la response
                        do {
                            //convertir reponse en NSDictionary
                            let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                
                            //parser json
                            if let parseJSON = myJSON {
                    
                                //creation string
                                var msg : String!
                    
                                //json reponse
                                msg = parseJSON["rep"] as! String?
                    
                                DispatchQueue.main.async {
                                self.validation (the_index: msg )
                        
                            }
                    
                        }
                } catch {
                        print(error)
                  }
            
                }
                //execution task
                task.resume()
            }
        
        else {
        
            self.alert_message (the_title: "Alert", the_msg:"Adresse E-mail invalide")
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
            
            print("badge contact = "+badge)
            
        }
        else {
            
            self.badgeLabel.text = ""+badge
            print("badge contact = "+badge)
        }
        
        self.name_field.delegate = self
        self.email_field.delegate = self
        self.tel_field.delegate = self
        let check_internet = (currentReachabilityStatus != .notReachable)
        
        if check_internet == false {
            
            self.alert_message (the_title: "Erreur Connexion", the_msg:"Cette page exige une connexion internet")
            
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name_field.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
