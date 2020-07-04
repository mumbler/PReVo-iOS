//
//  Mallongigo+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

import ReVoModeloj

extension Mallongigo {
    
    public static func elDatumbazObjekto(_ objekto: NSManagedObject) -> Mallongigo? {
        if let kodo = objekto.value(forKey: "kodo") as? String,
           let nomo = objekto.value(forKey: "nomo") as? String {
            return Mallongigo(kodo: kodo, nomo: nomo)
        }
        
        return nil
    }
}
