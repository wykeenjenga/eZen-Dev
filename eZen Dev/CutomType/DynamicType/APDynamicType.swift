//
//  AGDynamicType.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    var value: T? {
        didSet {
            bind?(value)
        }
    }
    
    var bind: ((T?)->())?
    
    init(_ _value: T) {
        value = _value
    }
    
    func unbind() {
        bind = nil
    }
}
