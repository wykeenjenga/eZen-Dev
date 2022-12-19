//
//  APAPIGateway.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

class APAPIGateway {
    
    private static let _door = APAPIGateway.init()
    
    @discardableResult class func door() -> APAPIGateway {
        return self._door
    }
    
    private init() {
    }
    
    var currentToken: String? {
        get {
            return firebase.currentToken
        }
    }
    
    func getProductDetail(barCode: String, completion: @escaping (APProductsModel, Error?) -> Void){
        //firebase.getProductDetail(barCode: barCode, completion: completion)
    }
}
