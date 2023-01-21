//
//  Accessors.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct Accessors {
    
    enum Storyboard: String {
        
        case main = "Main"
        
        func instantiate(with identifier: String) -> AnyObject {
            let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: identifier)
        }
    }
    
    struct AppDelegate {
        static let delegate: APAppDelegate = UIApplication.shared.delegate as! APAppDelegate
    }
}


class AVPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
