//
//  APTranscriptionViewController.swift
//  eZen Dev
//
//  Created by Wykee on 13/01/2023.
//  Copyright © 2023 Music of Wisdom. All rights reserved.
//

import UIKit

class APTranscriptionViewController: UIViewController {
    
    @IBOutlet weak var transcriptionText: UITextView!
    
    var words = [Utterance]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.transcriptionText.text = ""
    }
    
    final class func create() -> APTranscriptionViewController {
        let view = APTranscriptionViewController(nibName: "APTranscriptionViewController", bundle: nil)
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for word in words {
            self.transcriptionText.text += "\n \(word)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func onDismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func navigateToVideo(_ sender: Any) {
        
    }
    
}
