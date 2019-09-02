//
//  DatumbazAlirilo+VortSerchado.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/16/19.
//  Copyright © 2019 Sinuous Rill. All rights reserved.
//

import CoreData

public struct SerchStato {
    public var peto: String
    internal var iterator: TrieIterator
    public var rezultoj: [(String, [NSManagedObject])]
    public var atingisFinon: Bool
}

final public class TrieIterator {
    
    var nodStaplo = [NSManagedObject]()
    let locale: Locale
    
    init(lingvoKodo: String, komencaNodo: NSManagedObject?) {
        locale = Locale(identifier: lingvoKodo)
        
        if let komencaNodo = komencaNodo {
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

extension DatumbazAlirilo {
    
    public func serchi(lingvoKodo: String, teksto: String, komenco: Int? = 0, limo: Int) -> SerchStato {
        
        if let iterator = starigiTrieIteraror(lingvo: lingvoKodo, peto: teksto) {
            let stato = SerchStato(peto: teksto,
                                   iterator: iterator,
                                   rezultoj: [(String, [NSManagedObject])](),
                                   atingisFinon: false)
            
            return serchi(komencaStato: stato, limo: limo)
        }
        else {
            return SerchStato(peto: teksto,
                              iterator: TrieIterator(lingvoKodo: lingvoKodo, komencaNodo: nil),
                              rezultoj: [(String, [NSManagedObject])](),
                              atingisFinon: true)
        }
    }
    
    public func serchi(komencaStato stato: SerchStato, limo: Int) -> SerchStato {
        
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
    
    public func komencajNodojPorLingvo(_ lingvo: NSManagedObject) -> [NSManagedObject] {
        
        return Array(lingvo.value(forKey: "komencajNodoj") as! Set)
    }

    public func komencaNodo(por kodo: String, kunLitero litero: String) -> NSManagedObject? {
        
        guard let lingvoObjekto = lingvoPorKodo(kodo) else {
            return nil
        }
        
        return komencaNodo(el: lingvoObjekto, kunLitero: litero)
    }
    
    public func komencaNodo(el lingvo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
            
        let nodoj = komencajNodojPorLingvo(lingvo)
        
        if let trovo = nodoj.firstIndex(where: {
            (kontrol: NSManagedObject) -> Bool in
            return kontrol.value(forKey: "litero") as? String == litero
        }) {
            return nodoj[trovo]
        }
        
        return nil
    }
    
    public func sekvaNodo(el nodo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
        
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
    
    //Mark: TrieIteratorajhoj
    
    private func starigiTrieIteraror(lingvo: String, peto: String) -> TrieIterator? {
        
        guard peto.count > 0,
            let komencaNodo = komencaNodo(por: lingvo , kunLitero: String(peto.prefix(1))) else {
            return nil
        }
        
        var nunNodo = komencaNodo
        for nunLitero in String(peto.suffix(peto.count - 1)) {
            if let sekvaNodo = sekvaNodo(el: nunNodo, kunLitero: String(nunLitero)) {
                nunNodo = sekvaNodo
            }
            else {
                return nil
            }
        }
        
        return TrieIterator(lingvoKodo: lingvo, komencaNodo: nunNodo)
    }
}
