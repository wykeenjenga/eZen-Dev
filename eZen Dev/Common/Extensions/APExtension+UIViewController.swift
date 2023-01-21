//
//  APExtension+UIViewController.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    /// Create a new empty controller instance with given view
    ///
    /// - Parameters:
    ///   - view: view
    ///   - frame: frame
    /// - Returns: instance
    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }
}

extension UIViewController {
    func showAlert(title: String = ConstantStrings.kSorry, message: String = ConstantStrings.kExperiencingTechnicalIssue) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    func customPresent(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
}

extension UIApplication {
    /**
     Method to get the key window as keyWindow property of the UIAplication is depricated in iOS 13
     */
    func getKeyWindow() -> UIWindow? {
       return self.windows.first { $0.isKeyWindow }
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.getKeyWindow()?.rootViewController) -> UIViewController {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller ?? UIViewController()
    }
}

extension UIApplication {
    class func navigationTopViewController() -> UIViewController? {
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        return  nav?.topViewController
    }
}
