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
    
    func uploadVoiceOver(fileURL: URL, isAnalyze: Bool, completion: @escaping (URL?, Error?) -> Void){

        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": "Bearer \(self.token!)"
        ]
        
        var param_string = ""
        if isAnalyze{
            param_string = "dlb://ezen/analyze/\(fileURL.lastPathComponent)"
        }else{
            param_string = "dlb://ezen/enhance/\(fileURL.lastPathComponent)"
        }
        let parameters = ["url": param_string] as [String : Any]

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
                          if isAnalyze{
                              let source_input = "dlb://ezen/analyze/\(fileURL.lastPathComponent)"
                              self.analyzeAudio(fileURL: source_input) { job_id, error in
                                  if error == nil{
                                      self.checkJobStatus(job_id: "\(job_id)", isAnalyze: true) { _, _ in
                                      }
                                      print("ANALYZE JOB ID....\(job_id)")
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: {
                                          self.getResultsURL(isAnalyze: true) { status, error in
                                              if error == nil{
                                                  //start download
                                                  print("DOWNLOAD ANALYSED JSON File..\(status)")
                                                  self.downloadFile(downldURL: status, isAnalyze: true) { url, error in
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
                             
                          }else{
                              let source_input = "dlb://ezen/enhance/\(fileURL.lastPathComponent)"

                              self.enhanceAudio(fileURL: source_input) { job_id, error in
                                  if error == nil{
                                      self.checkJobStatus(job_id: "\(job_id)", isAnalyze: false) { _, _ in}
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: {
                                          self.getResultsURL(isAnalyze: false) { status, error in
                                              if error == nil{
                                                  //start download
                                                  print("TO DOWNLOAD ENHANCED URL.....\(status)")
                                                  self.downloadFile(downldURL: status, isAnalyze: false) { url, error in
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
                          }//end

                      }
                  }
              }
          }
        })
        dataTask.resume()
    }
    
    
    func analyzeAudio(fileURL: String, completion: @escaping (String, Error?) -> Void){
        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": "Bearer \(self.token!)"
        ]
        
        let parameters = [
            "input": "\(fileURL)",
            "output": "dlb://ezen/analyzed/enhanced_adminSample.json",
            "content": [
                "type": "podcast",
                "silence": [
                    "threshold": AnalysisValues.threshold,
                    "duration": AnalysisValues.duration
                ]
              ]
            ] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.dolby.com/media/analyze")! as URL,
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
                  let job_id = json["job_id"]
                  completion("\(job_id)", nil)
              }
          }
        })

        dataTask.resume()
        
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
          "output": "dlb://ezen/enhance/enhanced_adminSample.mp3",
          "content": ["type": EnhanceValues.econtent_type],
          "audio": [
            "loudness": [
                "enable": EnhanceValues.eloudness_enabled,
              "target_level": EnhanceValues.etarget_level,
                "dialog_intelligence": EnhanceValues.edialog_intelligence_enabled,
              "speech_threshold": EnhanceValues.espeech_threshold,
              "peak_limit": EnhanceValues.epeak_limit,
                "peak_reference": EnhanceValues.peak_reference
            ],
            "dynamics": ["range_control": [
                "enable": EnhanceValues.espeech_dynamic_enabled,
                "amount": EnhanceValues.espeech_dynamic_value
              ]],
            "noise": ["reduction": [
                "enable": EnhanceValues.enoise_reduction_enabled,
                "amount": EnhanceValues.enoise_reduction_value
              ]],
            "filter": [
              "dynamic_eq": ["enable": EnhanceValues.edynamic_eq_enabled],
              "high_pass": [
                "enable": EnhanceValues.efilter_highpass_enabled,
                "frequency": EnhanceValues.efilter_highpass_value
              ],
              "hum": ["enable": EnhanceValues.efilter_humreduct_enabled]
            ],
            "speech": [
              "isolation": [
                "enable": EnhanceValues.espeech_isolation_enabled,
                "amount": EnhanceValues.espeech_isolation_value
              ],
              "sibilance": ["reduction": [
                "enable": EnhanceValues.esibilance_reduction_enabled,
                "amount": EnhanceValues.esibilance_reduction_value
                ]],
              "plosive": ["reduction": [
                "enable": EnhanceValues.eplosive_reduction_enabled,
                "amount": EnhanceValues.eplosive_reduction_value
                ]],
              "click": ["reduction": [
                "enable": EnhanceValues.eclick_reduction_enabled,
                "amount": EnhanceValues.eclick_reduction_value
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
              }
          }
        })
        dataTask.resume()
    }
    
    func getAnalyzedData(job_id: String, completion: @escaping (JSON, Error?) -> Void){

        let headers: HTTPHeaders = [
            "accept": "application/json",
            "content-type": "application/json",
            "authorization": "Bearer \(self.token!)"
        ]

        let url = URL(string: "https://api.dolby.com/media/analyze")
        let parameters: Parameters = [
            "job_id": job_id
        ]
        AlamofireManager?.request(url!, method: .get, parameters: parameters, headers: headers).response(completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if response.value != nil{
                    let json = JSON(response.value)
                    completion(json, nil)
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
    
    func getResultsURL(isAnalyze: Bool,completion: @escaping (String, Error?) -> Void){

        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "authorization": "Bearer \(self.token!)"
        ]
        var param_string = ""
        let url = "https://api.dolby.com/media/output"
        
        if isAnalyze{
            param_string = "dlb://ezen/analyzed/enhanced_adminSample.json"
        }else{
            param_string = "dlb://ezen/enhance/enhanced_adminSample.mp3"
        }
        
        let parameters = ["url": param_string] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
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
                  completion("\(job_id)", nil)
              }
          }
        })

        dataTask.resume()
    }

    
    //Upload audio to Dolby APIs
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
    func checkJobStatus(job_id: String, isAnalyze: Bool, completion: @escaping(String, Error?) -> Void){

        var getURL = ""
        
        if isAnalyze{
            getURL = "https://api.dolby.com/media/analyze"
        }else{
            getURL = "https://api.dolby.com/media/enhance"
        }
        
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
                        self.checkJobStatus(job_id: job_id, isAnalyze: isAnalyze, completion: {_,_ in })
                    }else{
                        print("JO IS DONE YOU CAN DOWNLOAD.....\(json)")
                        
                        if isAnalyze{
                            completion("\(json)", nil)
                        }else{
                            completion(job_id, nil)
                        }
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
    func uploadToEzen(voiceOverUrl: URL, completion: @escaping(URL?, Error?) -> Void){
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
            multipartFormData.append(voiceOverUrl, withName: "file" , fileName: "ezenAdmin.mp3", mimeType: "Audio")}, to: endPoint, method: .post, headers: params).uploadProgress(closure: { (progress) in
                print("Progress...\(progress.fractionCompleted * 100)% uploaded to eZen")
            }).response { response in
                    switch(response.result) {
                    case .success(_):
                        if response.value != nil{
                            let json = JSON(response.value! as Any)
                            let play_file = json["play_file"]
                            print(".........RESPONSE AFTER UPLOADING TO EZEN.....\(play_file)......\(json)")
                            completion(voiceOverUrl, nil)
                            
//                            self.setFilter { file_dir, error in
//                                if error == nil{
//                                    //download file
//                                    print("AM ABOUT TO DOWNLOAD THIS GUY......\(file_dir)")
//                                    self.downloadFile(downldURL: "http://45.61.56.80/\(file_dir)", isAnalyze: false) { url, error in
//                                        if error == nil{
//                                            completion(url, nil)
//                                        }else{
//                                            completion(nil, error)
//                                        }
//                                    }
//                                }else{
//                                    completion(nil, error)
//                                }
//                            }
                            
//                            if AppSettings.isBellCurveEQAtcive{
//
//                            }else{
//                                print("*******IS NOT BELL CURVE GO DIRECT TO DOLBY DIRECT******************")
//                                completion(voiceOverUrl, nil)
//                                self.downloadFile(downldURL: "http://45.61.56.80/media/ezenAdminFiltered.mp3", isAnalyze: false) { url, error in
//                                    if error == nil{
//                                        completion(url, nil)
//                                    }else{
//                                        completion(nil, error)
//                                    }
//                                }
//                            }
//
                        }else{
                            completion(nil, nil)
                        }
                       break
                   case .failure(let encodingError):
                        completion(nil, encodingError)
                       break
                    }
                self.endBGTask()
                }
        }
    }
    
    func setFilter(completion: @escaping(String, Error?) -> Void){
        let url =  "http://45.61.56.80/api/setBellFilter"
        let parameters = ["id_file": "",
                          "frequency": BellCurveFilter.center_frequency,
                          "amplitude": BellCurveFilter.amplitude,
                          "bandwidth":BellCurveFilter.bandWidth,
                          "order":BellCurveFilter.order,
                          "fileName": "ezenAdmin"
        ] as [String : Any]
        
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
    
    
    func getTranscription(completion: @escaping(String, Error?) -> Void){
        let url =  "http://45.61.56.80/api/getTranscription"
        let parameters = ["fileName": "ezenAdmin"] as [String : Any]
        
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
                        print("Request response for audio transcription==>", json)
                        let data = json["response"].stringValue
                        print("We have the information....")
                        completion(data, nil)
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
    
    func applyNoiseGate(parts: [[Double]], completion: @escaping(URL?, Error?) -> Void){
        let url =  "http://45.61.56.80/api/ApplyNoiseGate"
        let parameters = ["parts": parts, "fileName": "ezenAdmin"] as [String : Any]
        
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
                            self.getTranscription { transcription, error in
                                if error == nil{
                                    self.downloadFile(downldURL: "http://45.61.56.80/media/ezenAdmingated.mp3", isAnalyze: false) { url, error in
                                        if error == nil{
                                            file_url.address = url
                                            completion(url, nil)
                                        }else{
                                            completion(nil, error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break
                case .failure(let error):
                    completion(nil, error.asAFError)
                    break
                }
                self.endBGTask()
            }
        }
    }

    
    func downloadFile(downldURL: String, isAnalyze: Bool, completion: @escaping(URL?, Error?) -> Void){
        
        var fileName = ""
        if isAnalyze{
            fileName = "analyzed_file.json"
        }else{
            fileName = "GuidedMeditation.mp3"
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        AlamofireManager!.download(downldURL, to: destination)
            .downloadProgress(queue: .main) { progress in
                print("Download Progress: \(progress.fractionCompleted * 100)%")
            }.responseData { response in
                print("***********DOWNLOAD_RESPONSE**********\(response.value)")
                if response.value != nil{
                    print("Done with the download of \(String(describing: response.fileURL))")
                    completion(response.fileURL!, nil)
                }else{
                    completion(nil, nil)
                }
            }
    }

}
