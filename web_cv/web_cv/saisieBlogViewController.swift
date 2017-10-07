//
//  saisieBlogViewController.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit

class saisieBlogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var title_label: UITextField!
    @IBOutlet weak var descr_label: UITextView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!

   
    
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
        
        let myUrl = NSURL(string: "http://rouibah.fr/search/blog_upload.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "title"  : title_label.text! ,
            "descr"    : descr_label.text!,
            "userId"    : "9"
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
