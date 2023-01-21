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
    @IBOutlet weak var eHubReduction: UISwitch!
    @IBOutlet weak var eQHighPassTF: UITextField!
    
//    @IBOutlet weak var bellAmplitude: UITextField!
//    @IBOutlet weak var bellFrequency: UITextField!
//    @IBOutlet weak var bellOrder: UITextField!
//    @IBOutlet weak var bandWidth: UITextField!
    
    @IBOutlet weak var analysisThreshold: UITextField!
    @IBOutlet weak var analysisDuration: UITextField!
    
    @IBOutlet weak var isSpeechIsolation: UISwitch!
    @IBOutlet weak var isEQHighPass: UISwitch!
    
    @IBOutlet weak var speechDynamicTF: UITextField!
    @IBOutlet weak var isSpeechDynamic: UISwitch!
    
    @IBOutlet weak var noiseReductionTF: UITextField!
    @IBOutlet weak var isNoiseReduction: UISwitch!
    
    @IBOutlet weak var sibilanceReductionTF: UITextField!
    @IBOutlet weak var isSibilanceReduction: UISwitch!
    
    @IBOutlet weak var plosiveReductionTF: UITextField!
    @IBOutlet weak var isPlosiveReduction: UISwitch!
    
    @IBOutlet weak var clickReductionTF: UITextField!
    @IBOutlet weak var isClickReduction: UISwitch!
    
    @IBOutlet weak var isDynamicEQ: UISwitch!
    @IBOutlet weak var isAudioLoudness: UISwitch!
    @IBOutlet weak var isDolbyGating: UISwitch!
    @IBOutlet weak var audioType: UITextField!
    @IBOutlet weak var peakReferenceTF: UITextField!
    
//    @IBOutlet weak var isBellCurveEQ: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.targetLevelTF.text = String(EnhanceValues.etarget_level)
        self.speechThresholdTF.text = String(EnhanceValues.espeech_threshold)
        self.peakLimitTF.text = String(EnhanceValues.epeak_limit)
        self.speechIsolationTF.text = String(EnhanceValues.espeech_isolation_value)
        self.eQHighPassTF.text = String(EnhanceValues.efilter_highpass_value)
        self.isSpeechIsolation.isOn = EnhanceValues.espeech_isolation_enabled
        self.isEQHighPass.isOn = EnhanceValues.efilter_highpass_enabled
        self.eHubReduction.isOn = EnhanceValues.efilter_humreduct_enabled
        self.isSpeechDynamic.isOn = EnhanceValues.espeech_dynamic_enabled
        self.speechDynamicTF.text = EnhanceValues.espeech_dynamic_value
        self.noiseReductionTF.text = EnhanceValues.enoise_reduction_value
        self.isNoiseReduction.isOn = EnhanceValues.enoise_reduction_enabled
        self.isSibilanceReduction.isOn = EnhanceValues.esibilance_reduction_enabled
        self.sibilanceReductionTF.text = EnhanceValues.esibilance_reduction_value
        self.plosiveReductionTF.text = EnhanceValues.eplosive_reduction_value
        self.isPlosiveReduction.isOn = EnhanceValues.eplosive_reduction_enabled
        self.clickReductionTF.text = EnhanceValues.eclick_reduction_value
        self.isClickReduction.isOn = EnhanceValues.eclick_reduction_enabled
        self.peakReferenceTF.text = EnhanceValues.peak_reference
        
        self.isDynamicEQ.isOn = EnhanceValues.edynamic_eq_enabled
        self.isAudioLoudness.isOn = EnhanceValues.eloudness_enabled
        self.isDolbyGating.isOn = EnhanceValues.edialog_intelligence_enabled
        self.audioType.text = EnhanceValues.econtent_type
        
//        self.bellAmplitude.text = String(BellCurveFilter.amplitude)
//        self.bellFrequency.text = String(BellCurveFilter.center_frequency)
//        self.bellOrder.text = String(BellCurveFilter.order)
//        self.bandWidth.text = String(BellCurveFilter.bandWidth)
//        self.isBellCurveEQ.isOn = AppSettings.isBellCurveEQAtcive
        
        self.analysisDuration.text = String(AnalysisValues.duration)
        self.analysisThreshold.text = String(AnalysisValues.threshold)
        
        
    }
    
    final class func create() -> APSettingsViewController {
        let view = APSettingsViewController(nibName: "APSettingsViewController", bundle: nil)
        return view
    }

    @IBAction func saveSettings(_ sender: Any) {
        print("Target Level is...\(targetLevelTF.text) and Speech threshold is...\(speechThresholdTF.text).....SPEEECH\(self.speechDynamicTF.text!)")
        
        //Save data
        EnhanceValues.etarget_level = Int(targetLevelTF.text!) ?? -18
        EnhanceValues.espeech_threshold = Int(speechThresholdTF.text!) ?? 15
        EnhanceValues.epeak_limit = Int(peakLimitTF.text!) ?? -1
        
        EnhanceValues.espeech_isolation_value = Int(speechIsolationTF.text!) ?? 90
        EnhanceValues.efilter_highpass_value = Int(eQHighPassTF.text!) ?? 80
        
        EnhanceValues.efilter_highpass_enabled = self.isEQHighPass.isOn
        EnhanceValues.espeech_isolation_enabled = self.isSpeechIsolation.isOn
        EnhanceValues.efilter_humreduct_enabled = self.eHubReduction.isOn
        
        EnhanceValues.econtent_type = self.audioType.text ?? "voice_over"
        EnhanceValues.peak_reference = self.peakReferenceTF.text ?? "true_peak"
        EnhanceValues.edynamic_eq_enabled = self.isDynamicEQ.isOn
        EnhanceValues.eloudness_enabled = self.isAudioLoudness.isOn
        EnhanceValues.edialog_intelligence_enabled = self.isDolbyGating.isOn
        
        EnhanceValues.espeech_dynamic_value = self.speechDynamicTF.text ?? "medium"
        EnhanceValues.espeech_dynamic_enabled = self.isSpeechDynamic.isOn
        
        EnhanceValues.enoise_reduction_value = self.noiseReductionTF.text ?? "auto"
        EnhanceValues.enoise_reduction_enabled = self.isNoiseReduction.isOn
        
        EnhanceValues.esibilance_reduction_value = self.sibilanceReductionTF.text ?? "medium"
        EnhanceValues.esibilance_reduction_enabled = self.isSibilanceReduction.isOn
        
        EnhanceValues.eplosive_reduction_value = self.plosiveReductionTF.text ?? "medium"
        EnhanceValues.eplosive_reduction_enabled = self.isPlosiveReduction.isOn
        
        EnhanceValues.eclick_reduction_value = self.clickReductionTF.text ?? "medium"
        EnhanceValues.eclick_reduction_enabled = self.isClickReduction.isOn
        
        AnalysisValues.threshold = Int(analysisThreshold.text!) ?? -60
        AnalysisValues.duration = Double(analysisDuration.text!) ?? 2.0
        
//        BellCurveFilter.amplitude = Int(bellAmplitude.text!) ?? -10
//        BellCurveFilter.center_frequency = Int(bellFrequency.text!) ?? 500
//        BellCurveFilter.order = Int(self.bellOrder.text!) ?? 2
//        BellCurveFilter.bandWidth = Int(self.bandWidth.text!) ?? 100
//
//        AppSettings.isBellCurveEQAtcive = self.isBellCurveEQ.isOn
        
        self.dismiss(animated: true)
        
    }
    
}
