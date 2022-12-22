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
    func enhanceAudio()
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
    func enhanceAudio() {
        self.route.value = .activity(loading: true)
        print("THE URL IS ...\(String(describing: self.initFile.value))")
        
        APAPIGateway.door().uploadVoiceOver(fileURL: self.initFile.value!!, isAnalyze: false) { url, error in
            self.route.value = .activity(loading: false)
            if error != nil{
                self.route.value = .error
            }else{
                //
                file_url.address = url
                print("File status is....\(url)")
                self.equalizeAudio()
            }
        }
    }
    
    
    func equalizeAudio(){
        self.route.value = .activity(loading: true)
        APAPIGateway.door().uploadToEzen(voiceOverUrl: file_url.address!) { url, error in
            self.route.value = .activity(loading: false)
            if error != nil{
                self.route.value = .error
            }else{
                file_url.address = url
                print("File status is..AFTER BELL Curve filter EQ..\(url)")
                //self.route.value = .isPreview
                self.getSilentParts()
            }
        }
    }
    
    func getSilentParts(){
        self.route.value = .activity(loading: true)
        print("THE URL IS ...\(String(describing: file_url.address!))")
        
        APAPIGateway.door().uploadVoiceOver(fileURL: file_url.address!, isAnalyze: true) { url, error in
            self.route.value = .activity(loading: false)
            if error != nil{
                self.route.value = .error
            }else{
                //
                file_url.address = url
                
                print("JSON File DATA is from....\(url)")
                
                loadData()
            }
        }
    }
    
    func loadData(){
        var json: Any?
        do {
            let fileUrl = URL(fileURLWithPath: file_url.address!.path)
            // Getting data from JSON file using the file URL
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            json = try? JSONSerialization.jsonObject(with: data)
            
            print("JSON DATA IS...\(json)")
        } catch {
            // Handle error here
            print("CAMNmmm")
        }
    }
    
}

