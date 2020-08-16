//
//  Destino.swift
//  ReVoModeloj
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

#if os(iOS)
import ReVoModeloj
#elseif os(macOS)
import ReVoModelojOSX
#endif

public struct Destino {
    let artikolObjekto: NSManagedObject
    public let indekso: String
    public let marko: String?
    public let nomo: String
    public let senco: String?
    public let teksto: String
    
    public init?(objekto: NSManagedObject) {
        
        guard let artikolObjekto = objekto.value(forKey: "artikolo") as? NSManagedObject else {
            return nil
        }
        
        self.artikolObjekto = artikolObjekto
        
        guard let indekso = objekto.value(forKey: "indekso") as? String,
            let marko = objekto.value(forKey: "marko") as? String,
            let nomo = objekto.value(forKey: "nomo") as? String,
            let teksto = objekto.value(forKey: "teksto") as? String else {
                return nil
        }

        let senco = objekto.value(forKey: "senco") as? String
        
        self.indekso = indekso
        self.marko = marko
        self.nomo = nomo
        self.senco = senco
        self.teksto = teksto
    }

    
    public func artikolo(enVortaro vortaro: VortaroDatumbazo) -> Artikolo? {
        return Artikolo.elDatumbazObjekto(objekto: artikolObjekto, datumbazo: vortaro)
    }
}

// MARK: - Equatable

extension Destino: Equatable {
    public static func ==(lhs: Destino, rhs: Destino) -> Bool {
        return lhs.indekso == rhs.indekso &&
            lhs.marko == rhs.marko &&
            lhs.nomo == rhs.marko &&
            lhs.senco == rhs.senco &&
            lhs.teksto == rhs.teksto &&
            lhs.artikolObjekto == rhs.artikolObjekto
    }
}

// MARK: - Comparable

extension Destino: Comparable {
    public static func < (lhs: Destino, rhs: Destino) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
