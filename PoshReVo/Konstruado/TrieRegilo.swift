//
//  TrieRegilo.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import CoreData

/*
    La trie regilo faras la trie parton de la datumbazo, kaj havas kapablon traserchi
    ghin por trovi vortojn
*/
class TrieRegilo {
    
    static var konteksto: NSManagedObjectContext?
    
    // ====================================
    // Trie farado
    // ====================================
    
    static func konstruiChiuTrie(_ kodoj: [String]) {
        
        // ["om"] has one entry - starts with W
        for lingvo in ["eo"] /*kodoj*/ {
            konstruiTriePorLingvo(lingvo)
        }
        //konstruiTriePorLingvo("eo")
    }
    
    static func konstruiTriePorLingvo(_ kodo: String) {
        
        if let tradukoURL = Bundle.main.url(forResource: "indekso_" + kodo, withExtension: "dat") {
            
            let lingvoObjekto = DatumLegilo.lingvoPorKodo(kodo)
            if lingvoObjekto == nil {
                return
            }
            
            do {
                let tradukoData = try Data(contentsOf: tradukoURL)
                let tradukoJSON = try JSONSerialization.jsonObject(with: tradukoData, options: JSONSerialization.ReadingOptions())
                //let tradukoJSON = try JSONSerialization.JSONObjectWithStream(tradukoData, options: JSONSerialization.ReadingOptions())
                
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
                            
                            for nunLitero in teksto!.lowercased() {
                                
                                var sekvaNodo: NSManagedObject? = nil
                                if nunNodo == nil {
                                    if let trovNodo = komencaNodo(el: lingvoObjekto!, kunLitero: String(nunLitero)) {
                                        sekvaNodo = trovNodo
                                    }
                                } else {
                                    if let trovNodo = self.sekvaNodo(el: nunNodo!, kunLitero: String(nunLitero)) {
                                        sekvaNodo = trovNodo
                                    }
                                }
                                
                                if sekvaNodo == nil {
                                    sekvaNodo = NSEntityDescription.insertNewObject(forEntityName: "TrieNodo", into: konteksto!)
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
                                let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto!)
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
                        
                        if let konteksto = konteksto {
                            konteksto.persistentStoreCoordinator?.performAndWait { () -> Void in
                                do {
                                    try konteksto.save()
                                } catch {
                                    NSLog("ERARO 2")
                                }
                            }
                        }
                    } // Chiu traduko
                    
                    //konteksto?.save()
                }
            } catch {
                NSLog("ERARO")
            }
        }

    }
    
    // ====================================
    // Trie navigaciado
    // ====================================
    
    static func serchi(lingvoKodo: String, teksto: String, limo: Int) -> [(String, [NSManagedObject])] {
        
        if konteksto == nil {
            return [(String, [NSManagedObject])]()
        }
        
        
        /*
         let serchPeto = NSFetchRequest()
        serchPeto.entity = NSEntityDescription.entityForName("Artikolo", inManagedObjectContext: konteksto!)
        serchPeto.predicate = NSPredicate(format: "indekso LIKE %@", argumentArray: [teksto + "%"])
        do {
            let rezultoj = try konteksto!.executeFetchRequest(serchPeto).first as? NSManagedObject
            
        } catch { }
        
        return [(String, [NSManagedObject])]()
        */
        
        var nunNodo: NSManagedObject? = nil
        var sekvaNodo: NSManagedObject? = nil
        
        for nunLitero in teksto {
            
            sekvaNodo = nil
            if nunNodo == nil {
                if let lingvo = DatumLegilo.lingvoPorKodo(lingvoKodo) {
                    sekvaNodo = komencaNodo(el: lingvo , kunLitero: String(nunLitero))
                }
            } else {
                sekvaNodo = self.sekvaNodo(el: nunNodo!, kunLitero: String(nunLitero))
            }
            
            if sekvaNodo != nil {
                nunNodo = sekvaNodo
            } else {
                return [(String, [NSManagedObject])]()
            }
        }
        
        if nunNodo != nil {
            return chiuFinajho(nunNodo!, limo: limo ) /*.sort({ (unua: (String, NSManagedObject), dua: (String, NSManagedObject)) -> Bool in
                return unua.0 < dua.0
            })*/
        } else {
            return [(String, [NSManagedObject])]()
        }
    }
    
    // Trovi chiun vorton kiu havas komence la jam trovitan tekston
    static func chiuFinajho(_ nodo: NSManagedObject, limo: Int) -> [(String, [NSManagedObject])] {
        
        var rezultoj = [(String, [NSManagedObject])]()
        
        var trovoj = [String : [NSManagedObject]]()
        for destino in nodo.mutableOrderedSetValue(forKey: "destinoj") {
            if let veraDestino = destino as? NSManagedObject, let destTeksto = veraDestino.value(forKey: "teksto") as? String {
                if trovoj[destTeksto] == nil { trovoj[destTeksto] = [NSManagedObject]() }
                trovoj[destTeksto]?.append(veraDestino)
            }
        }
        for (teksto, destinoj) in trovoj {
            rezultoj.append( (teksto, destinoj))
        }
        
        if let sekvaj = ((nodo.value(forKey: "sekvajNodoj") as? NSSet)?.allObjects as? [NSManagedObject])?.sorted(by: { (unua: NSManagedObject, dua: NSManagedObject) -> Bool in
            return (unua.value(forKey: "litero") as? String ?? "") < (dua.value(forKey: "litero") as? String ?? "")
        }) {
            
            for sekvaNodo in sekvaj {
                
                rezultoj.append(contentsOf: chiuFinajho(sekvaNodo, limo: limo))
                if rezultoj.count > limo {
                    return Array(rezultoj.prefix(limo))
                }
            }
        }
        
        return rezultoj
    }
    
    static func komencajNodojPorLingvo(_ lingvo: NSManagedObject) -> [NSManagedObject] {
        
        return Array(lingvo.value(forKey: "komencajNodoj") as! Set)
    }
    
    static func komencaNodo(el lingvo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
        
        let nodoj = komencajNodojPorLingvo(lingvo)

        if let trovo = nodoj.firstIndex(where: {
            (kontrol: NSManagedObject) -> Bool in
            return kontrol.value(forKey: "litero") as? String == litero
        }) {
            return nodoj[trovo]
        }
        
        return nil
    }
    
    static func sekvaNodo(el nodo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
        
        if let sekvaj: [NSManagedObject] = (nodo.value(forKey: "sekvajNodoj") as? NSSet)?.allObjects as? [NSManagedObject] {
        
            if let trov = sekvaj.firstIndex(where: {
                (kontrol: NSManagedObject) -> Bool in
                return kontrol.value(forKey: "litero") as? String == litero
            }) {
                return sekvaj[trov]
            }
        }
        
        return nil
    }

}

