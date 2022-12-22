//
//  SilentParts.swift
//  eZen Dev
//
//  Created by Wykee on 22/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

// MARK: - SilentPart
struct SilentPart: Codable {
    let sectionID: String
    let channels: [String]
    let start, duration: Double

    enum CodingKeys: String, CodingKey {
        case sectionID = "section_id"
        case channels, start, duration
    }
}

typealias SilentParts = [SilentPart]
