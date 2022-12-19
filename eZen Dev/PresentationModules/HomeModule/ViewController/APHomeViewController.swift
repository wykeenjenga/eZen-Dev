//
//  APHomeViewController.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import UIKit

class APHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    final class func create() -> APHomeViewController {
        let view = APHomeViewController(nibName: "APHomeViewController", bundle: nil)
        return view
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
