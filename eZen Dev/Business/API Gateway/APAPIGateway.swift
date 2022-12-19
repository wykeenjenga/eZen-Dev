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
    
    func getProductDetail(barCode: String, completion: @escaping (String, Error?) -> Void){
        //firebase.getProductDetail(barCode: barCode, completion: completion)
    }
}
