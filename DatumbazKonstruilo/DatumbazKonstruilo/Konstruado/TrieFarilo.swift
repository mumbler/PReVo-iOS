//
//  TrieFarilo.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import CoreData

/*
    La trie farilo faras la trie parton de la datumbazo
*/
final class TrieFarilo {
    
    // ====================================
    // Trie farado
    // ====================================
    
    static func konstruiChiuTrie(en konteksto: NSManagedObjectContext, kodoj: [String]) {
        
        for lingvo in kodoj {
            konstruiTriePorLingvo(en: konteksto, kodo: lingvo)
        }
    }
    
    static func konstruiTriePorLingvo(en konteksto: NSManagedObjectContext, kodo: String) {
        
        if let tradukoURL = Bundle.main.url(forResource: "indekso_" + kodo, withExtension: "dat") {
            
            let lingvoObjekto = DatumLegilo.lingvoPorKodo(kodo)
            if lingvoObjekto == nil {
                return
            }
            
            do {
                let tradukoData = try Data(contentsOf: tradukoURL)
                let tradukoJSON = try JSONSerialization.jsonObject(with: tradukoData, options: JSONSerialization.ReadingOptions())
                
                if let tradukoj = tradukoJSON as? NSArray {
                    
                    var nunNodo: NSManagedObject? = nil
                    for traduko in tradukoj {
                        
                        if let enhavoj = traduko as? NSDictionary {
                            // Kiel dict: indekso, senco, teksto, marko
                            
                            let videbla = enhavoj["videbla"] as? String
                            let teksto = enhavoj["teksto"] as? String
                            let nomo = enhavoj["nomo"] as? String
                            let indekso = enhavoj["indekso"] as? String
                            let marko = enhavoj["marko"] as? String
                            let senco = enhavoj["senco"] as! Int
                            
                            for nunLitero in teksto! {
                                
                                var sekvaNodo: NSManagedObject? = nil
                                if nunNodo == nil {
                                    if let trovNodo = TrieLegilo.komencaNodo(el: lingvoObjekto!, kunLitero: String(nunLitero)) {
                                        sekvaNodo = trovNodo
                                    }
                                } else {
                                    if let trovNodo = TrieLegilo.sekvaNodo(el: nunNodo!, kunLitero: String(nunLitero)) {
                                        sekvaNodo = trovNodo
                                    }
                                }
                                
                                if sekvaNodo == nil {
                                    sekvaNodo = NSEntityDescription.insertNewObject(forEntityName: "TrieNodo", into: konteksto)
                                    sekvaNodo?.setValue(String(nunLitero), forKey: "litero")
                                    
                                    if nunNodo == nil {
                                        lingvoObjekto?.mutableSetValue(forKey: "komencajNodoj").add(sekvaNodo!)
                                    } else {
                                        nunNodo?.mutableSetValue(forKey: "sekvajNodoj").add(sekvaNodo!)
                                    }
                                }
                                
                                nunNodo = sekvaNodo
                                
                            }
                            
                            if indekso != nil {
                                let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
                                novaDestino.setValue(videbla, forKey: "teksto")
                                novaDestino.setValue(indekso, forKey: "indekso")
                                novaDestino.setValue(nomo, forKey: "nomo")
                                novaDestino.setValue(marko, forKey: "marko")
                                novaDestino.setValue(String(senco), forKey: "senco")
                                if let artikolo = DatumLegilo.artikoloPorIndekso(indekso!) {
                                    novaDestino.setValue(artikolo, forKey: "artikolo")
                                }
                                nunNodo?.mutableOrderedSetValue(forKey: "destinoj").add(novaDestino)
                            }
                            
                            nunNodo = nil
                        } // Enhavoj de la traduko
                        
                    } // Chiu traduko
                    
                    try konteksto.save()
                }
            } catch {
                NSLog("ERARO")
            }
        }

    }
}

