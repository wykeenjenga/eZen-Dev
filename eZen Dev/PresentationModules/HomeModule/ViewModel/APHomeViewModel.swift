//
//  APHomeViewModel.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

enum APHomeViewModelRoute {
    case initial
    case error
    case activity(loading: Bool)
    case isUploadFile
}

protocol APHomeViewModelInput {
    func startProcessing()
}

protocol APHomeViewModelOutput {
    var route: Dynamic<APHomeViewModelRoute> { get set }
}

protocol APHomeViewModel: APHomeViewModelInput, APHomeViewModelOutput {
}

final class DefaultAPHomeViewModel: APHomeViewModel {
    var route: Dynamic<APHomeViewModelRoute> = Dynamic(.initial)
    init() {
    }
}

extension APHomeViewModel{
    
    //MARK: upload file and do the enhancement
    //return type: job id download file..
    func startProcessing() {
        
    }
    
    func equalizeAudio(){
        
    }
    
    func getSilentParts(){
        
    }
    
    func downloadFinalAudio(){
        
    }
}
