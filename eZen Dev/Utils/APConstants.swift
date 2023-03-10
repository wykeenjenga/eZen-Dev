//
//  APConstants.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct ConstantStrings{
    static let kEmailTitle = "Welcome!"
    static let kSorry = "Sorry!"
    static let kExperiencingTechnicalIssue = "We are experience some technical problem. Please try again later."
    static let kOk = "OK"
}

struct OnboardingImages{
    static let mic = UIImage(named: "mic")
    static let headphones = UIImage(named: "Headphone")
    static let meditate = UIImage(named: "meditate")
}

struct OnboardingTitles{
    static let mic = "Record Your Meditation"
    static let meditate = "Edit & Add Background Music"
    static let headphones = "Share Your Meditation"
}

struct OnboardingSubTitles{
    static let mic = "Record guided meditation on your phone using eZen built-in voice recorder. "
    static let meditate = "Remove background noise from your voice, and add music to your guided meditation."
    static let headphones = "Save the final guided meditation on your phone and share it with your audience!"
}


struct EnhanceValues{
    static var etarget_level = -18
    static var espeech_threshold = 15
    static var epeak_limit = -1
    static var efilter_highpass_enabled = true
    static var espeech_isolation_enabled = true
    static var efilter_highpass_value = 80
    static var espeech_isolation_value = 100
    
    static var econtent_type = "voice_over"
    static var peak_reference = "true_peak"
    static var eloudness_enabled = true
    static var edialog_intelligence_enabled = true
    static var edynamic_eq_enabled =  true
    
    static var efilter_humreduct_enabled = true
    
    static var espeech_dynamic_value = "medium"
    static var espeech_dynamic_enabled = true
    
    static var enoise_reduction_value = "auto"
    static var enoise_reduction_enabled = true
    
    static var esibilance_reduction_value = "medium"
    static var esibilance_reduction_enabled = true
    
    static var eplosive_reduction_value = "medium"
    static var eplosive_reduction_enabled = true
    
    static var eclick_reduction_value = "medium"
    static var eclick_reduction_enabled = true
    
}

struct AnalysisValues{
    static var threshold = -50
    static var duration = 0.5
}


struct BellCurveFilter{
    static var amplitude = -10
    static var center_frequency = 500
    static var order = 2
    static var bandWidth = 100
}

struct AppSettings{
    static var isBellCurveEQAtcive = true
}
