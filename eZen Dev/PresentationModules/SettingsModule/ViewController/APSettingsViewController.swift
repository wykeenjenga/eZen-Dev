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
        print("IS to dismiss....")
    }
    
    
    
    @IBOutlet weak var targetLevelTF: UITextField!
    @IBOutlet weak var speechThresholdTF: UITextField!
    @IBOutlet weak var peakLimitTF: UITextField!
    @IBOutlet weak var speechIsolationTF: UITextField!
    @IBOutlet weak var eQHighPassTF: UITextField!
    
    
    @IBOutlet weak var bellAmplitude: UITextField!
    @IBOutlet weak var bellFrequency: UITextField!
    
    @IBOutlet weak var analysisThreshold: UITextField!
    @IBOutlet weak var analysisDuration: UITextField!
    
    
    @IBOutlet weak var isSpeechIsolation: UISwitch!
    @IBOutlet weak var isEQHighPass: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    final class func create() -> APSettingsViewController {
        let view = APSettingsViewController(nibName: "APSettingsViewController", bundle: nil)
        return view
    }

    @IBAction func saveSettings(_ sender: Any) {
        print("Target Level is...\(targetLevelTF.text) and Speech threshold is...\(speechThresholdTF.text)")
        if targetLevelTF.text != "" && speechThresholdTF.text != "" && peakLimitTF.text != "" && speechIsolationTF.text != "" && eQHighPassTF.text != "" && bellAmplitude.text != "", bellFrequency.text != "" && analysisThreshold.text != "" && analysisThreshold.text != "" {
            //Save data
            EnhanceValues.target_level = Int(targetLevelTF.text!) ?? -18
            EnhanceValues.speech_threshold = Int(speechThresholdTF.text!) ?? 15
            EnhanceValues.peak_limit = Int(peakLimitTF.text!) ?? -1
            
            EnhanceValues.speech_isolation_value = Int(speechThresholdTF.text!) ?? 90
            EnhanceValues.filter_highpass_value = Int(eQHighPassTF.text!) ?? 80
            
            EnhanceValues.filter_highpass_enabled = self.isEQHighPass.isOn
            EnhanceValues.speech_isolation_enabled = self.isSpeechIsolation.isOn
            
            AnalysisValues.threshold = Int(analysisThreshold.text!) ?? -60
            AnalysisValues.duration = Int(analysisDuration.text!) ?? 2
            
            BellCurveFilter.amplitude = Int(bellAmplitude.text!) ?? -10
            BellCurveFilter.center_frequency = Int(bellFrequency.text!) ?? 500
            
            print("isEQ==\(self.isEQHighPass.isOn), and isSpeech==\(self.isSpeechIsolation.isOn)")
            self.dismiss(animated: true)
        }else{
            self.dismiss(animated: true)
        }
        
    }
    
}
