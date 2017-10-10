//
//  saisieBlogViewController.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import Foundation


class saisieBlogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var badgeLabel: UILabel!
    
    var badge = ""
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var title_label: UITextField!
    @IBOutlet weak var descr_label: UITextView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
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

   
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
    
    
   
        
        myImageUploadRequest()
        
    }
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
    
    
   
        
        let myPickerController = UIImagePickerController ()
        
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
   
     internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        myImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://rouibah.fr/search/web.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "title"  : title_label.text! ,
            "descr"    : descr_label.text!,
            
            "demande" : "insertBlog"
        ] as [String : Any]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(myImageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param as? [String : String], filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
           
            print("******* response = \(String(describing: response))")
            
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json as Any)
                
                DispatchQueue.main.async(execute: {
                    self.myActivityIndicator.stopAnimating()
                    //self.myImageView.image = nil;
                });
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let xBadge = UserDefaults.standard.object(forKey: "badgeValue")  as? String{
            
            badge = xBadge
        }
        
        if badge == "0" {
            self.badgeLabel.text = ""
            self.badgeLabel.backgroundColor = UIColor(white: 1, alpha: 0)
            
        }
        else {
            
            self.badgeLabel.text = ""+badge
        }
        
        
        
        self.title_label.delegate = self
        let check_internet = (currentReachabilityStatus != .notReachable)
        
        if check_internet == false {
            
            self.alert_message (the_title: "Erreur Connexion", the_msg:"Cette page exige une connexion internet")
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        title_label.resignFirstResponder()
        return true
    }
    

  

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
