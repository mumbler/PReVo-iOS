//
//  Lingvo+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/3/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

import ReVoModeloj

extension Lingvo {
    public static func elDatumbazObjekto(_ objekto: NSManagedObject) -> Lingvo? {
        if let kodo = objekto.value(forKey: "kodo") as? String,
           let nomo = objekto.value(forKey: "nomo") as? String {
            return Lingvo(kodo: kodo, nomo: nomo)
        }
        
        return nil
    }
    
    public static var esperanto: Lingvo {
        return Lingvo(kodo: "eo", nomo: "Esperanto")
    }
}

extension Lingvo: Comparable {
    public static func < (lhs: Lingvo, rhs: Lingvo) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
