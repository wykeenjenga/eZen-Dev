//
//  AppDelegate.swift
//  eZen Dev
//
//  Created by Wykee on 17/12/2022.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON

@main
class APAppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate{
    
    var window: UIWindow?
    let appDiContainer = APDIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.getAPIToken()
        navigateToOnboarding()
        IQKeyboardManager.shared.enable = true
        return true
    }

    func navigateToOnboarding() {
        if let onboarding = Accessors.Storyboard.main.instantiate(with: "OnBoardingScreen") as? UIViewController {
            if UIApplication.shared.keyWindow == nil {
                self.window?.rootViewController = onboarding
                self.window?.makeKeyAndVisible()
            }else{
                UIApplication.shared.keyWindow?.setRootViewController(onboarding, options: UIWindow.TransitionOptions(direction: .toRight))
            }
        } else {
            assertionFailure("Could not load onboarding screen")
        }
    }

    func getAPIToken() {
        let headers = [
          "accept": "application/json",
          "Cache-Control": "no-cache",
          "Content-Type": "application/x-www-form-urlencoded",
          "authorization": "Basic bGZ0MkhlVXFrTDA0MEdTMEpqSWZ1Zz09OnZ3bV9YMjd4MmN1Rzd3RDNiWmRVRERja2lHcFdERHB5MV9wRFRiMnZIekk9"
          ]

        let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
        postData.append("&expires_in=86400".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.dolby.io/v1/auth/token")! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
              if(jsonData == nil) {
                  print("Could not parse data")
              }else{
                  let json = JSON(jsonData as Any)
                  let token = json["access_token"]
                  print("TOKEN IS///........\(token)")
                  UserDefaults.standard.setValue("\(token)", forKey: "APP_TOKEN")
              }

          }
        })

        dataTask.resume()
        
        
    }

}

