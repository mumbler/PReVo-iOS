//
//  TrieLegilo.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/16/19.
//  Copyright © 2019 Sinuous Rill. All rights reserved.
//

import CoreData

struct SerchStato {
    var peto: String
    var iterator: TrieIterator
    var rezultoj: [(String, [NSManagedObject])]
    var atingisFinon: Bool
}

class TrieIterator {
    
    var nodStaplo = [NSManagedObject]()
    let locale: Locale
    
    init(lingvo: String, peto: String) {
        
        var nunNodo: NSManagedObject? = nil
        var sekvaNodo: NSManagedObject? = nil
        
        locale = Locale(identifier: lingvo)
        
        for nunLitero in peto {
            
            sekvaNodo = nil
            if nunNodo == nil {
                sekvaNodo = TrieLegilo.komencaNodo(por: lingvo , kunLitero: String(nunLitero))
            } else {
                sekvaNodo = TrieLegilo.sekvaNodo(el: nunNodo!, kunLitero: String(nunLitero))
            }
            
            if sekvaNodo != nil {
                nunNodo = sekvaNodo
            } else {
                nunNodo = nil
                break
            }
        }
        
        if let komencaNodo = nunNodo {
            nodStaplo.append(komencaNodo)
        }
    }
    
    func next() -> (String, [NSManagedObject])? {
        
        while let nodo = nodStaplo.popLast() {
            
            if let filoj = ((nodo.mutableSetValue(forKey: "sekvajNodoj")).allObjects as? [NSManagedObject])?.sorted(by: { (unua: NSManagedObject, dua: NSManagedObject) -> Bool in
                let unuaLitero = (unua.value(forKey: "litero") as? String) ?? ""
                let duaLitero = (dua.value(forKey: "litero") as? String) ?? ""
                return unuaLitero.compare(duaLitero, options: .forcedOrdering, range: nil, locale: locale) == .orderedDescending
                //return unuaLitero < duaLitero
            }) {
                for filo in filoj {
                    nodStaplo.append(filo)
                }
            }
            
            if let destinoj = nodo.mutableOrderedSetValue(forKey: "destinoj").array as? [NSManagedObject],
                let teksto = destinoj.first?.value(forKey: "teksto") as? String {
                
                return (teksto, destinoj)
            }
        }
        return nil
    }
}

final class TrieLegilo {
    
    // Publikaj metodoj
    
    public static func serchi(lingvoKodo: String, teksto: String, komenco: Int? = 0, limo: Int) -> SerchStato {
        
        let iterator = TrieIterator(lingvo: lingvoKodo, peto: teksto)
        let stato = SerchStato(peto: teksto,
                               iterator: iterator,
                               rezultoj: [(String, [NSManagedObject])](),
                               atingisFinon: false)
        
        return serchi(komencaStato: stato, limo: limo)
    }
    
    public static func serchi(komencaStato stato: SerchStato, limo: Int) -> SerchStato {
        
        var rezultoj = stato.rezultoj
        var atingisFinon = false
        
        for _ in 0..<limo {
            if let sekva = stato.iterator.next() {
                rezultoj.append(sekva)
            }
            else {
                atingisFinon = true
                break
            }
        }
        
        let finaStato = SerchStato(peto: stato.peto,
                                   iterator: stato.iterator,
                                   rezultoj: rezultoj,
                                   atingisFinon: atingisFinon)
        return finaStato
    }
    
    public static func komencajNodojPorLingvo(_ lingvo: NSManagedObject) -> [NSManagedObject] {
        
        return Array(lingvo.value(forKey: "komencajNodoj") as! Set)
    }

    public static func komencaNodo(por kodo: String, kunLitero litero: String) -> NSManagedObject? {
        
        guard let lingvoObjekto = DatumLegilo.lingvoPorKodo(kodo) else {
            return nil
        }
        
        return komencaNodo(el: lingvoObjekto, kunLitero: litero)
    }
    
    public static func komencaNodo(el lingvo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
            
        let nodoj = komencajNodojPorLingvo(lingvo)
        
        if let trovo = nodoj.firstIndex(where: {
            (kontrol: NSManagedObject) -> Bool in
            return kontrol.value(forKey: "litero") as? String == litero
        }) {
            return nodoj[trovo]
        }
        
        return nil
    }
    
    public static func sekvaNodo(el nodo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
        
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
