//
//  SettingsDIContainer.swift
//  eZen Dev
//
//  Created by Wykee on 23/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

final class APSettingsDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeSettingsViewController() -> APSettingsViewController {
        return APSettingsViewController.create()
    }
}
