//
//  Listero.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Sinuous Rill. All rights reserved.
//

import Foundation

/* Listero estas ghenerala objekto por reprezenti artikolon en
   liston ekzemple la historio, kaj havas apartan nomon por montri
*/
final class Listero : NSObject, NSCoding {
    
    let nomo: String, indekso: String
    
    init(_ ennomo: String, _ enindekso: String) {
        nomo = ennomo
        indekso = enindekso
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let ennomo = aDecoder.decodeObject(forKey: "nomo") as? String,
            let enindekso = aDecoder.decodeObject(forKey: "indekso") as? String {
            self.init(ennomo, enindekso)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nomo, forKey: "nomo")
        aCoder.encode(indekso, forKey: "indekso")
    }
}
