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
public final class Lingvo : NSObject, NSSecureCoding {
    
    public let kodo: String
    public let nomo: String
    
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
    
    // MARK: - NSSecureCoding

    public static var supportsSecureCoding = true
    
    public required convenience init?(coder aDecoder: NSCoder) {
        if let enkodo = aDecoder.decodeObject(forKey: "kodo") as? String,
            let ennomo = aDecoder.decodeObject(forKey: "nomo") as? String {
            self.init(kodo: enkodo, nomo: ennomo)
        } else {
            return nil
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(kodo, forKey: "kodo")
        aCoder.encode(nomo, forKey: "nomo")
    }
    
    public override var hash: Int {
        return kodo.hashValue
    }
}

// MARK: - Equatable

extension Lingvo {
    
    public override func isEqual(_ object: Any?) -> Bool {
        if let lingvo = object as? Lingvo {
            return self == lingvo
        }
        else {
            return false
        }
    }
    
    public static func ==(lhs: Lingvo, rhs: Lingvo) -> Bool {
        return lhs.kodo == rhs.kodo && lhs.nomo == rhs.nomo
    }
}
