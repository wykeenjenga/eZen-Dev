//
//  HUDLoaderProtocol.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//
import Foundation
import MBProgressHUD

protocol HUDLoaderProtocol {
    func showHUD(with text: String?)
    func hideHUD()
    func showHUDOnWindow()
    func hideHUDFromWindow()
}

extension HUDLoaderProtocol where Self: UIViewController {
    
    func hideHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func showHUD(with text: String? = nil) {
        MBProgressHUD.showAdded(to: view, animated: true)
        if text != nil {
            let hud = MBProgressHUD(view: view)
            hud.label.text = text
            hud.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
    }
    
    func showHUDOnWindow() {
        guard let window = UIApplication.shared.keyWindow else {
            MBProgressHUD.showAdded(to: view, animated: true)
            return
        }
        MBProgressHUD.showAdded(to: window, animated: true)
    }
    
    func hideHUDFromWindow() {
        guard let window = UIApplication.shared.keyWindow else {
            MBProgressHUD.hide(for: view, animated: true)
            return
        }
        MBProgressHUD.hide(for: window, animated: true)
    }
}
