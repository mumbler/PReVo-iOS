//
//  DatumbazAlirilo+VortSerchado.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 8/16/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

// Kopio de samnoma dosiero en ReVoDatumbazo. Ĝi estas privata tiel ke la apo ne vidu ĝin,
// sed ĝi estas tre helpa ĉi tie. Mi ne volas fari ion pli kompleksan.
// Forigis iom da nenecesa kodo el la originala
extension DatumbazAlirilo {
    func komencajNodojPorLingvo(_ lingvo: NSManagedObject) -> [NSManagedObject] {
        
        return Array(lingvo.value(forKey: "komencajNodoj") as! Set)
    }

    func komencaNodo(por kodo: String, kunLitero litero: String) -> NSManagedObject? {
        
        guard let lingvoObjekto = lingvo(porKodo: kodo) else {
            return nil
        }
        
        return komencaNodo(el: lingvoObjekto, kunLitero: litero)
    }
    
    func komencaNodo(el lingvo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
            
        let nodoj = komencajNodojPorLingvo(lingvo)
        
        if let trovo = nodoj.firstIndex(where: {
            (kontrol: NSManagedObject) -> Bool in
            return kontrol.value(forKey: "litero") as? String == litero
        }) {
            return nodoj[trovo]
        }
        
        return nil
    }
    
    func sekvaNodo(el nodo: NSManagedObject, kunLitero litero: String) -> NSManagedObject? {
        
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
