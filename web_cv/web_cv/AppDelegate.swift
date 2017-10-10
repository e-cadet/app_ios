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
        }else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        if let xBadge = UserDefaults.standard.object(forKey: "badgeValue")  as? String{
            let badge = Int(xBadge)!
            application.applicationIconBadgeNumber = badge
            
            
        }
        
        
        // Envoyé lorsque l'application est sur le point de passer de l'état actif à l'état inactif. Cela peut se produire pour certains types d'interruptions temporaires (comme un appel téléphonique entrant ou un message SMS) ou lorsque l'utilisateur quitte l'application et qu'il commence la transition vers l'état d'arrière-plan.
          // Utilisez cette méthode pour suspendre les tâches en cours, désactiver les minuteries et invalider les rappels de rendu graphique. Les jeux doivent utiliser cette méthode pour mettre le jeu en pause.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Utilisez cette méthode pour libérer des ressources partagées, enregistrer des données utilisateur, invalider les minuteries et stocker suffisamment d'informations sur l'état de l'application pour restaurer votre application dans son état actuel au cas où elle se terminerait ultérieurement.
        // Si votre application prend en charge l'exécution en arrière-plan, cette méthode est appelée à la place de applicationWillTerminate: lorsque l'utilisateur se ferme.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Appelé dans le cadre de la transition de l'arrière-plan à l'état actif; ici vous pouvez annuler un grand nombre des modifications apportées à l'entrée en arrière-plan.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
       // Redémarrez toutes les tâches mises en pause (ou pas encore démarrées) pendant que l'application était inactive. Si l'application était précédemment en arrière-plan, actualisez éventuellement l'interface utilisateur.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Appelé lorsque l'application est sur le point de se terminer. Sauvegarder les données le cas échéant. Voir aussi applicationDidEnterBackground :.
    }
    
//==================================================================================================
   
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            // Convertir  token en string
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        
        
        
        UserDefaults.standard.set(deviceTokenString, forKey: "tokenValue")
       
      
        //Envoyer token vers php bdd
        let liens = "http://rouibah.fr/search/ApnsPHP/notification.php"
        
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

