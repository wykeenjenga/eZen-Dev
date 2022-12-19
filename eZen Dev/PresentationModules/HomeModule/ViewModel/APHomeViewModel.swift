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
    //return type: job id download file..
    func startProcessing() {
        self.route.value = .activity(loading: true)
        print("THE URL IS ...\(self.initFile.value)")
        
        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": ""
        ]
        
        let parameters = ["url": "dlb://input/file.wav"] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.dolby.com/media/input")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
          }
        })

        dataTask.resume()
        
    }
    
    func equalizeAudio(){
        
    }
    
    func getSilentParts(){
        
    }
    
    func downloadFinalAudio(){
        
    }
}
