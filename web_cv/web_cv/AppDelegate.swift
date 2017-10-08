//
//  AppDelegate.swift
//  web_cv
//
//  Created by rouibah on 01/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
   


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // iOS 10
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//==================================================================================================
   
    class func getDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
        
        
    }
   
    
    
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            // Convertir  token en string
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        
        
        //var badge = application.applicationIconBadgeNumber
            
        
            
        // Print sur la console
        print("APNs device token: \(deviceTokenString)")
        
       
       
      
        //Envoyer token vers php bdd
        let liens = "http://rouibah.fr/search/web.php"
        
        let requestURL = NSURL(string: liens)
        let demande = "token"
        let request = NSMutableURLRequest(url:requestURL! as URL )
        request.httpMethod = "POST"
        let postParameters = "demande="+demande+"&token="+deviceTokenString;
        
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
                        
                        print(msg)
                        
                    }
                } catch {
                    print(error)
                }
                
            }
            //executer task
            task.resume()
            
        }
        
        
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("APNs registration failed: \(error)")
    }
    
 
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }


}

