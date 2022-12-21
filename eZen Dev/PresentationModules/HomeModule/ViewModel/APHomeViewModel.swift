//
//  APHomeViewModel.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation
import Alamofire

enum APHomeViewModelRoute {
    case initial
    case error
    case activity(loading: Bool)
    case isUploadFile
    case isPreview
    case isEnhanced
}

protocol APHomeViewModelInput {
    func startProcessing()
}

protocol APHomeViewModelOutput {
    var route: Dynamic<APHomeViewModelRoute> { get set }
    var initFile: Dynamic<URL?> {get set}
}

protocol APHomeViewModel: APHomeViewModelInput, APHomeViewModelOutput {
}

final class DefaultAPHomeViewModel: APHomeViewModel {
    var route: Dynamic<APHomeViewModelRoute> = Dynamic(.initial)
    var initFile: Dynamic<URL?> = Dynamic(nil)
    
    init() {
    }
}

extension APHomeViewModel{
    
    //MARK: upload file and do the enhancement
    func startProcessing() {
        self.route.value = .activity(loading: true)
        print("THE URL IS ...\(String(describing: self.initFile.value))")
        
        APAPIGateway.door().uploadVoiceOver(fileURL: self.initFile.value!!) { url, error in
            self.route.value = .activity(loading: false)
            if error != nil{
                self.route.value = .error
            }else{
                self.route.value = .isPreview
                file_url.address = url
                print("File status is....\(url)")
            }
        }
    }
    
    
    
    
    func equalizeAudio(){
        APAPIGateway.door().uploadVoiceOver(voiceOverUrl: file_url.address!) { url, error in
            self.route.value = .activity(loading: false)
            if error != nil{
                self.route.value = .error
            }else{
                print("File status is....\(url)")
            }
        }
    }
    
    func getSilentParts(){
        
    }
    
    func downloadFinalAudio(){
        
    }
}
