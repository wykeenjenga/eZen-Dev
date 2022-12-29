//
//  PreviewVoiceOverDIContainer.swift
//  eZen
//
//  Created by Wykee Njenga on 9/28/22.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

final class APPreviewVoiceOverDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makePreviewViewController() -> APPreviewAudioViewController {
        return APPreviewAudioViewController.create(with: viewModel())
    }
    
    private func viewModel() -> APHomeViewModel{
        return DefaultAPHomeViewModel()
    }
}


