//
//  Destino+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

import ReVoModeloj

extension Destino {
    public static func elDatumbazObjekto(_ objekto: NSManagedObject, datumbazo: VortaroDatumbazo) -> Destino? {
        guard let indekso = objekto.value(forKey: "indekso") as? String,
            let nomo = objekto.value(forKey: "nomo") as? String,
            let senco = objekto.value(forKey: "senco") as? String,
            let teksto = objekto.value(forKey: "teksto") as? String,
            let artikolObjekto = objekto.value(forKey: "artikolo") as? NSManagedObject,
            let artikolo = Artikolo.elDatumbazObjekto(objekto: artikolObjekto, datumbazo: datumbazo) else {
                return nil
        }
        
        let marko = objekto.value(forKey: "marko") as? String
        
        return Destino(indekso: indekso,
                       marko: marko,
                       nomo: nomo,
                       senco: senco,
                       teksto: teksto,
                       artikolo: artikolo)
    }
}
