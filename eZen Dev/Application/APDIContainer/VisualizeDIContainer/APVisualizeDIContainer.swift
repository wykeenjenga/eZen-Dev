//
//  APVisualizeDIContainer.swift
//  eZen Dev
//
//  Created by Wykee on 06/01/2023.
//  Copyright © 2023 Music of Wisdom. All rights reserved.
//

import Foundation

final class APVisualizeDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeVisualViewController() -> APVisualizeViewController {
        return APVisualizeViewController.create()
    }
}
