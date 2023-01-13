//
//  APTranscriptionDIContainer.swift
//  eZen Dev
//
//  Created by Wykee on 13/01/2023.
//  Copyright © 2023 Music of Wisdom. All rights reserved.
//

import Foundation

final class APTranscriptionDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTranscriptViewController() -> APTranscriptionViewController {
        return APTranscriptionViewController.create()
    }
}
