//
//  AppDelegate.swift
//  eZen Dev
//
//  Created by Wykee on 17/12/2022.
//

import UIKit
import IQKeyboardManagerSwift

@main
class APAppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate{
    
    var window: UIWindow?
    let appDiContainer = APDIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

}

