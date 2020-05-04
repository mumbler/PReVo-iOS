//
//  Lingvo.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import Foundation

/*
    La lingvo objekto estas uzata por elekti kiun lingvon uzi por
    serchado, kaj kiujn lingvojn montri en la traduka sekcio de
    artikolo
*/
final class Lingvo : NSObject, NSCoding {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
    
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
    
    override var hash: Int {
        return kodo.hashValue
    }
}
