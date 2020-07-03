//
//  Lingvo.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas lingvon ekzistantan en la vortaro.
    Uzata en serĉado kaj listigado de tradukoj en artikoloj.
*/
final class Lingvo : NSObject, NSSecureCoding {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
    
    // MARK: - NSSecureCoding

    static var supportsSecureCoding = true
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let enkodo = aDecoder.decodeObject(forKey: "kodo") as? String,
            let ennomo = aDecoder.decodeObject(forKey: "nomo") as? String {
           self.init(enkodo, ennomo)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(kodo, forKey: "kodo")
        aCoder.encode(nomo, forKey: "nomo")
    }
    
    override var hash: Int {
        return kodo.hashValue
    }
}

// MARK: - Equatable

extension Lingvo {
    
    override func isEqual(_ object: Any?) -> Bool {
        if let lingvo = object as? Lingvo {
            return self == lingvo
        }
        else {
            return false
        }
    }
    
    static func ==(lhs: Lingvo, rhs: Lingvo) -> Bool {
        return lhs.kodo == rhs.kodo && lhs.nomo == rhs.nomo
    }
}
