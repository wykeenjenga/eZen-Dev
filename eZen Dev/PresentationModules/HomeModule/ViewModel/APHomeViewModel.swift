//
//  APHomeViewModel.swift
//  eZen
//
//  Created by Wykee Njenga on 9/26/22.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation
import Loaf

enum APHomeViewModelRoute {
    case initial
    case back
    case error
    case activity(loading: Bool)
    case isrecord
    case isUploadFile
}

protocol APHomeViewModelInput {
    func performSignIn(email: String, customEmail: String)
}

protocol APHomeViewModelOutput {
    var route: Dynamic<APHomeViewModelRoute> { get set }
    var tempEmail: Dynamic<String> {get set}
    var isOtherEmails: Dynamic<Bool> {get set}
    var isEmailRequest: Dynamic<Bool> {get set}
    var isRecord: Dynamic<Bool> {get set}
    var isCooseFile: Dynamic<Bool> {get set}
}

protocol APHomeViewModel: APHomeViewModelInput, APHomeViewModelOutput {
}

final class DefaultAPHomeViewModel: APHomeViewModel {
    var route: Dynamic<APHomeViewModelRoute> = Dynamic(.initial)
    var tempEmail: Dynamic<String> = Dynamic("")
    var isOtherEmails: Dynamic<Bool> = Dynamic(false)
    var isEmailRequest: Dynamic<Bool> = Dynamic(false)
    var isRecord: Dynamic<Bool> = Dynamic(false)
    var isCooseFile: Dynamic<Bool> = Dynamic(false)
    init() {
    }
}

extension APHomeViewModel{
    
    func performSignIn(email: String, customEmail: String){
        self.route.value = .activity(loading: true)
        self.isOtherEmails.value = true
        
        let Url = String(format: RequestURL.base_data + "api/v1/email/")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["email" : email]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(customEmail, forKey: "email")
                    UserDefaults.standard.set(email, forKey: "user")
                    self.isEmailRequest.value = false
                    if self.isRecord.value!{
                        self.route.value = .isrecord
                    }else if self.isCooseFile.value!{
                        self.route.value = .isUploadFile
                    }
                    self.tempEmail.value = customEmail
                    self.route.value = .activity(loading: false)
                }
            }else{
                DispatchQueue.main.async {
                    self.route.value = .error
                }
            }
        }.resume()
    }
    
    
    
}
