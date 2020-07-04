//
//  SerchStato.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

import ReVoModeloj

public struct SerchStato {
    internal var iterator: TrieIterator
    public var rezultoj: [(String, [Destino])]
    public var peto: String
    public var atingisFinon: Bool
    
    init(internaStato: SerchStatoInterna, datumbazo: VortaroDatumbazo) {
        peto = internaStato.peto
        iterator = internaStato.iterator
        atingisFinon = internaStato.atingisFinon
        
        rezultoj = internaStato.rezultoj.map { rezulto in
            (
                rezulto.0,
                rezulto.1.compactMap {
                    Destino.elDatumbazObjekto($0, datumbazo: datumbazo)
                }
            )
        }
    }
}

struct SerchStatoInterna {
    var peto: String
    var iterator: TrieIterator
    var rezultoj: [(String, [NSManagedObject])]
    var atingisFinon: Bool
}
