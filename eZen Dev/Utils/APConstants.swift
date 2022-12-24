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
    static var target_level = -18
    static var speech_threshold = 15
    static var peak_limit = -1
    static var filter_highpass_enabled = true
    static var speech_isolation_enabled = true
    
    static var filter_highpass_value = 80
    static var speech_isolation_value = 90
}

struct AnalysisValues{
    static var threshold = -60
    static var duration = 2
}


struct BellCurveFilter{
    static var amplitude = -10
    static var center_frequency = 500
    static var order = 2
    static var bandWidth = 100
}
