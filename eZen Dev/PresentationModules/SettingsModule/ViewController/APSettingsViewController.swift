//
//  APSettingsViewController.swift
//  eZen Dev
//
//  Created by Wykee on 23/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import UIKit

class APSettingsViewController: UIViewController {

    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    final class func create() -> APSettingsViewController {
        let view = APSettingsViewController(nibName: "APSettingsViewController", bundle: nil)
        return view
    }


}
