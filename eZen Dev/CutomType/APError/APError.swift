//
//  APError.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

struct APError : Error {
    var localizedTitle: String?
    var localizedDescription: String?
}
