//
//  APHomeViewModel.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
    func equalizeAudio()
}

protocol APHomeViewModelOutput {
    var route: Dynamic<APHomeViewModelRoute> { get set }
    var initFile: Dynamic<URL?> {get set}
    var sectionsArray: Dynamic<[[Double]]> {get set}
}

protocol APHomeViewModel: APHomeViewModelInput, APHomeViewModelOutput {
}

final class DefaultAPHomeViewModel: APHomeViewModel {
    var route: Dynamic<APHomeViewModelRoute> = Dynamic(.initial)
    var initFile: Dynamic<URL?> = Dynamic(nil)
    var sectionsArray: Dynamic<[[Double]]> = Dynamic([])
    
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
                self.route.value = .isPreview
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
                print("GETTING SILENCE PARTS..\(url)")
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
        do {
            let fileUrl = URL(fileURLWithPath: file_url.address!.path)
            // Getting data from JSON file using the file URL
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            //json = try? JSONSerialization.jsonObject(with: data)
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            if(jsonData == nil) {
                print("Could not parse data")
            }else{
                let json = JSON(jsonData as Any)
                
                let processed_region = json["processed_region"]
                //print("JSON DATA IS...\(processed_region)")
                
                let audio = processed_region["audio"]
                
                let silence = audio["silence"]
                
                let sections = silence["sections"]
                
                let dd = "\(sections)"
                print("DD", dd)
                
                let jsonDD = """
                \(dd)
                """.data(using: .utf8)!

                do {
                    let parts = try? JSONDecoder().decode([SilentPart].self, from: jsonDD)
                    for part in parts!{
                        let start = part.start
                        let end = part.duration + start
                        
                        var sectionPart = [Double]()
                        //"(\(start),\(end))"
                        
                        sectionPart.append(start)
                        sectionPart.append(end)
                        
                        self.sectionsArray.value?.append(sectionPart)
                        
                        print("SECTION ADDED....\(sectionPart)")
                        sectionPart.removeAll()
                        
                    }
                } catch {
                    print(error)
                }
            }
            let ss = "\(self.sectionsArray.value!)"
            print("NOW THE WHOLE PARTS IS ......\(ss)")
            self.applyNoiseGate()
           
        } catch {
            // Handle error here
            print("CAMNmmm")
        }
    }
    
    func applyNoiseGate(){
        self.route.value = .activity(loading: true)
        APAPIGateway.door().applyNoiseGate(parts: self.sectionsArray.value!) { url, error in
            self.route.value = .activity(loading: false)
            if error != nil{
                self.route.value = .error
            }else{
                print("NEW GATED URL IS..\(url)")
                self.route.value = .isPreview
            }
        }
    }
}



