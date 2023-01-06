//
//  APDIContainer.swift
//  eZen Dev
//
//  Created by Wykee on 17/12/2022.
//

import Foundation

final class APDIContainer {
    // MARK: - Network
    ///Network to be init
}

extension APDIContainer {
    // MARK: DIContainers of scenes
    
    /// Creates Home DIContainer.
    func makeHomeDIContainer() -> APHomeDIContainer {
        let dependencies = APHomeDIContainer.Dependencies()
        return APHomeDIContainer(dependencies: dependencies)
    }
    
    /// Creates Home DIContainer.
    func makePreviewDIContainer() -> APPreviewVoiceOverDIContainer {
        let dependencies = APPreviewVoiceOverDIContainer.Dependencies()
        return APPreviewVoiceOverDIContainer(dependencies: dependencies)
    }
    
    /// Creates Home DIContainer.
    func makeSettingsDIContainer() -> APSettingsDIContainer {
        let dependencies = APSettingsDIContainer.Dependencies()
        return APSettingsDIContainer(dependencies: dependencies)
    }
    
    /// Creates VIsualize DIContainer.
    func makeVisualizeDIContainer() -> APVisualizeDIContainer {
        let dependencies = APVisualizeDIContainer.Dependencies()
        return APVisualizeDIContainer(dependencies: dependencies)
    }
}
