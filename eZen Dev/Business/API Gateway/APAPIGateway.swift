//
//  APAPIGateway.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APAPIGateway {
    
    private static let _door = APAPIGateway.init()
    
    @discardableResult class func door() -> APAPIGateway {
        return self._door
    }
    
    private init() {
    }
    
    let token = UserDefaults.standard.string(forKey: "APP_TOKEN")
    var backgroundTaskID = UIBackgroundTaskIdentifier.invalid
    
    private var AlamofireManager: Session? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20000
        let alamofireManager = Session(configuration: configuration)
        return alamofireManager
    }()
    
    func uploadVoiceOver(fileURL: URL, completion: @escaping (URL, Error?) -> Void){

        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": "Bearer \(self.token!)"
        ]
        
        let parameters = ["url": "dlb://ezen/\(fileURL.lastPathComponent)"] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.dolby.com/media/input")! as URL, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
              if(jsonData == nil) {
                  print("Could not parse data")
              }else{
                  let json = JSON(jsonData as Any)
                  let url = json["url"]
                  
                  self.uploadAudiox(fileURL: fileURL, endPoint: "\(url)") { stats, error in
                      if error == nil{
                          let source_input = "dlb://Wykee19N/\(fileURL.lastPathComponent)"
                          print("IS FILE UPLOADED?....\(stats)")
                          self.enhanceAudio(fileURL: source_input) { job_id, error in
                              if error == nil{
                                  self.checkJobStatus(job_id: "\(job_id)") { data, error in
                                  }
                                  DispatchQueue.main.asyncAfter(deadline: .now() + 14, execute: {
                                      print("AFTER ENHANCING....\(job_id)")
                                      self.getEnhancedAudioURL { status, error in
                                          if error == nil{
                                              //start download
                                              print("TO DOWNLOAD URL.....\(status)")
                                              self.downloadVoice(voiceUrl: status) { url, error in
                                                  if error == nil{
                                                      completion(url, error)
                                                  }
                                              }
                                          }else{
                                              //show error
                                          }
                                      }
                                  })
                              }else{
                                  //show error
                              }
                          }
                      }
                  }
              }
          }
        })
        dataTask.resume()
    }
    
    func downloadVoice(voiceUrl: String, completion: @escaping(URL, Error?) -> Void){
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("Guided_Meditation.mp3")
            return (documentsURL, [.removePreviousFile])
        }
        AlamofireManager!.download(voiceUrl, to: destination)
            .downloadProgress(queue: .main) { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }.responseData { response in
                if response.value != nil{
                    print("Done with the download of \(String(describing: response.fileURL))")
                    completion(response.fileURL!, nil)
                }else{
                    completion(URL(string: "")!, nil)
                }
            }
    }
    
    
    
    func enhanceAudio(fileURL: String, completion: @escaping (String, Error?) -> Void){
        print("fucking string is ....\(fileURL)")
        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": "Bearer \(self.token!)"
        ]
        
        let parameters = [
          "input": "\(fileURL)",
          "output": "dlb://ezen/enhanced_adminSample.mp3",
          "content": ["type": "podcast"],
          "audio": [
            "loudness": [
              "enable": true,
              "target_level": -18,
              "dialog_intelligence": true,
              "speech_threshold": 15,
              "peak_limit": -1,
              "peak_reference": "true_peak"
            ],
            "dynamics": ["range_control": [
                "enable": true,
                "amount": "medium"
              ]],
            "noise": ["reduction": [
                "enable": true,
                "amount": "auto"
              ]],
            "filter": [
              "dynamic_eq": ["enable": true],
              "high_pass": [
                "enable": true,
                "frequency": 80
              ],
              "hum": ["enable": true]
            ],
            "speech": [
              "isolation": [
                "enable": true,
                "amount": 90
              ],
              "sibilance": ["reduction": [
                  "enable": true,
                  "amount": "medium"
                ]],
              "plosive": ["reduction": [
                  "enable": true,
                  "amount": "medium"
                ]],
              "click": ["reduction": [
                  "enable": false,
                  "amount": "medium"
                ]]
            ],
            "music": ["detection": ["enable": false]]
          ]
        ] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.dolby.com/media/enhance")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
              if(jsonData == nil) {
                  print("Could not parse data")
              }else{
                  let json = JSON(jsonData as Any)
                  let job_id = json["job_id"]
                  
                  completion("\(job_id)", nil)
                  print("THE JOB ID IS.....\(data)...jobID...\(job_id)")
              }
          }
        })
        dataTask.resume()
    }
    
    
    func getEnhancedAudioURL(completion: @escaping (String, Error?) -> Void){

        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": "Bearer \(self.token!)"
        ]
        let parameters = ["url": "dlb://ezen/enhanced_adminSample.mp3"] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.dolby.com/media/output")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
              if(jsonData == nil) {
                  print("Could not parse data")
              }else{
                  let json = JSON(jsonData as Any)
                  let job_id = json["url"]
                  completion(job_id.rawValue as! String, nil)
              }
          }
        })

        dataTask.resume()
    }

    
    func uploadAudiox(fileURL: URL, endPoint: String, completion: @escaping (String, Error?) -> Void){
        
        let params: HTTPHeaders = [
            "Content-type": "audio/wav"
        ]
        
        let endPoint = URL(string: "\(endPoint)")
        
        DispatchQueue.global().async {
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "FNT") {
                // End the task if time expires.
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            
            self.AlamofireManager!.upload(fileURL, to: endPoint!, method: .put, headers: params).uploadProgress(closure: { (progress) in
                    print("Progress...\(progress.fractionCompleted * 100) %")
                }).response { response in
                    switch(response.result) {
                    case .success(_):
                        if response.value != nil{
                            completion("\(response.value)", nil)
                        }else{
                            completion("nil", nil)
                        }
                        break
                    case .failure(let encodingError):
                        completion("nil", encodingError)
                        break
                    }
                    self.endBGTask()
                }
        }
    }
    
    var time = 0
    
    func checkJobStatus(job_id: String, completion: @escaping(String, Error?) -> Void){

        let getURL = "https://api.dolby.com/media/enhance"
        
        let headers: HTTPHeaders = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": "Bearer \(self.token!)"
        ]
        
        let parameters: Parameters = [
            "job_id": job_id
        ]
        AlamofireManager?.request(getURL, method: .get, parameters: parameters, headers: headers).response(completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if response.value != nil{
                    let json = JSON(response.value)
                    let status = json["status"]
                    
                    if status != "Success"{
                        print("Checking JOb Status.......\(status).....\(self.time)")
                        self.time = self.time + 1
                        self.checkJobStatus(job_id: job_id, completion: {_,_ in })
                    }else{
                        print("JO IS DONE YOU CAN DOWNLOAD.....\(json)")
                        completion(job_id, nil)
                    }
                    
                }else{
                    print("DDDDD")
                }
                break
            case .failure(let encodingError):
                print("ZRrorro")
                break
            }
        })
    }
    
    
    func endBGTask(){
        // End the task assertion.
        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
        self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
    }
    
    
    ///Upload  your Voice Over -API Request
    func uploadVoiceOver(voiceOverUrl: URL, completion: @escaping(Bool, Error?) -> Void){
        let params : HTTPHeaders = [
            "directoryName": "ezenAdmin",
            "fileName": "ezenAdmin"
        ]
        
        let endPoint = "http://45.61.56.80/api/Silence"
        
        print("THE END_POINT IS....\(endPoint)")
        
        DispatchQueue.global().async {
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "FNT") {
               // End the task if time expires.
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            
            self.AlamofireManager!.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(voiceOverUrl, withName: "file" , fileName: voiceOverUrl.description, mimeType: "Audio")}, to: endPoint, method: .post, headers: params).uploadProgress(closure: { (progress) in
            }).response { response in
                    switch(response.result) {
                    case .success(_):
                        if response.value != nil{
                            let json = JSON(response.value! as Any)
                            let play_file = json["play_file"]
                            print(".........RESPONSE AFTER Silince silence.....\(play_file)......\(json)")
                            self.setFilter { file_dir, error in
                                if error == nil{
                                    //download file
                                    print("AM ABOUT TO DOWNLOAD THIS GUY......\(file_dir)")
                                }else{
                                    completion(false, nil)
                                }
                            }
                        }else{
                            completion(false, nil)
                        }
                       break
                   case .failure(let encodingError):
                        completion(false, encodingError)
                       break
                    }
                self.endBGTask()
                }
        }
    }
    
    func setFilter(completion: @escaping(String, Error?) -> Void){
        let url =  "http://45.61.56.80/api/Silence"
        let parameters = ["id_file": "","hight": 0,"low": 0, "fileName": "ezenAdmin"] as [String : Any]
        
        var errorMessage = "Oops! Sorry your connection with the server was interrupted. Please retry to continue."
        
        DispatchQueue.global().async {
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "FNT") {
                // End the task if time expires.
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            
            self.AlamofireManager!.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default).responseJSON{response in
                switch(response.result) {
                case .success(_):
                    if response.value != nil{
                        let json = JSON(response.value!)
                        print("Request response for set Friter=>", json)
                        if json["IsSucces"].boolValue {
                            let id_file = json["id_file"]
                            completion("\(id_file)", nil)
                        }
                    }
                    break
                case .failure(let error):
                    completion("", error.asAFError)
                    break
                }
                self.endBGTask()
            }
        }
    }

}
