//
//  APIEndPoints.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

struct APAPIEndPoints {
    struct Requests {
        static func enhanceEndPoint() -> URL {
            return (URL(string: APAppConfigurations.apiBaseURL)?.appendingPathComponent("enhance"))!
        }
        
        static func analyzeEndPoint() -> URL {
            return (URL(string: APAppConfigurations.apiBaseURL)?.appendingPathComponent("analyze"))!
        }
    }
}

