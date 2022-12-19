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
