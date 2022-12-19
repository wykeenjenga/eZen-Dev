//
//  HomeDIContainer.swift
//  eZen Dev
//
//  Created by Wykee on 17/12/2022.
//

import Foundation

final class APHomeDIContainer {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeViewController() -> APHomeViewController {
        return APHomeViewController.create(with: viewModel())
    }
    
    private func viewModel() -> APHomeViewModel{
        return DefaultAPHomeViewModel()
    }
    
}
