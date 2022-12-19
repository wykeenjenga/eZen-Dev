//
//  APAppConfigurations.swift
//  eZen Dev
//
//  Created by Wykee on 17/12/2022.
//

import Foundation

struct APAppConfigurations {
    static var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "DolbyAPI") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
