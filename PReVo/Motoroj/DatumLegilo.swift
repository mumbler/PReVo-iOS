//
//  DatumLegilo.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import CoreData

/*
    Chi tiu klaso legas la datumojn faritajn de la Ruby-programeto kaj uzas ilin
    cele al konstrui Core Data datumbazon por posta uzado.
*/
class DatumLegilo {
    
    static var konteksto: NSManagedObjectContext?
    
    static func fariDatumbazon() {
        
        if konteksto == nil {
            return
        }
        
        var lingvoKodoj = ["eo"]
        
        // Enlegi lingvojn
        if let lingvoDos = NSBundle.mainBundle().pathForResource("lingvoj", ofType: "dat") {
            do {
                if let lingvoDat = NSData(contentsOfFile: lingvoDos) {
                    let lingvoJ = try NSJSONSerialization.JSONObjectWithData(lingvoDat, options: NSJSONReadingOptions())
                    
                    if let listo = lingvoJ as? NSArray {
                        
                        for lingvo in listo {
                            if let enhavoj = lingvo as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Lingvo", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                                if let kodo = enhavoj[0] as? String {
                                    lingvoKodoj.append(kodo)
                                }
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de lingvo-datumbaz-objektoj")
            }
        }
        
        // Enlegi fakojn
        if let fakoDos = NSBundle.mainBundle().pathForResource("fakoj", ofType: "dat") {
            do {
                if let fakoDat = NSData(contentsOfFile: fakoDos) {
                    let fakoJ = try NSJSONSerialization.JSONObjectWithData(fakoDat, options: NSJSONReadingOptions())
                    
                    if let listo = fakoJ as? NSArray {
                        
                        for fako in listo {
                            if let enhavoj = fako as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Fako", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de fako-datumbaz-objektoj")
            }
        }
        
        // Enlegi stilojn
        if let stiloDos = NSBundle.mainBundle().pathForResource("stiloj", ofType: "dat") {
            do {
                if let stiloDat = NSData(contentsOfFile: stiloDos) {
                    let stiloJ = try NSJSONSerialization.JSONObjectWithData(stiloDat, options: NSJSONReadingOptions())
                    
                    if let listo = stiloJ as? NSArray {
                        
                        for stilo in listo {
                            if let enhavoj = stilo as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Stilo", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de stilo-datumbaz-objektoj")
            }
        }
        
        // Enlegi mallongigojn
        if let mallongigoDos = NSBundle.mainBundle().pathForResource("mallongigoj", ofType: "dat") {
            do {
                if let mallongigoDat = NSData(contentsOfFile: mallongigoDos) {
                    let mallongigoJ = try NSJSONSerialization.JSONObjectWithData(mallongigoDat, options: NSJSONReadingOptions())
                    
                    if let listo = mallongigoJ as? NSArray {
                        
                        for mallongigo in listo {
                            if let enhavoj = mallongigo as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Mallongigo", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de mallongigo-datumbaz-objektoj")
            }
        }
        
        // Enlegi mallongigojn
        if let artikoloDos = NSBundle.mainBundle().pathForResource("vortoj", ofType: "dat") {
            do {
                if let artikoloDat = NSData(contentsOfFile: artikoloDos) {
                    let artikoloJ = try NSJSONSerialization.JSONObjectWithData(artikoloDat, options: NSJSONReadingOptions())
                    
                    if let listo = artikoloJ as? NSArray {
                        
                        for artikolo in listo {
                            if let enhavoj = artikolo as? NSDictionary {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Artikolo", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj["titolo"], forKey: "titolo")
                                novaObjekto.setValue(enhavoj["radiko"], forKey: "radiko")
                                novaObjekto.setValue(enhavoj["indekso"], forKey: "indekso")
                                let tradukDatumoj = try NSJSONSerialization.dataWithJSONObject(enhavoj["tradukoj"]!, options: NSJSONWritingOptions())
                                novaObjekto.setValue(tradukDatumoj, forKey: "tradukoj")
                                let vortDatumoj = try NSJSONSerialization.dataWithJSONObject(enhavoj["objekto"]!, options: NSJSONWritingOptions())
                                novaObjekto.setValue(vortDatumoj, forKey: "vortoj")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de artikolo-datumbaz-objektoj")
            }
        }
        
        TrieRegilo.konstruiChiuTrie(lingvoKodoj)
        
    }
    
    // =============================
    // Helpaj funkcioj
    // =============================
    
    // Trovado de kelkaj objekt-tipojn
    
    static func chiujLingvoj() -> [NSManagedObject]? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest()
        serchPeto.entity = NSEntityDescription.entityForName("Lingvo", inManagedObjectContext: konteksto!)
        do {
            return try konteksto!.executeFetchRequest(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    static func chiujFakoj() -> [NSManagedObject]? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest()
        serchPeto.entity = NSEntityDescription.entityForName("Fako", inManagedObjectContext: konteksto!)
        do {
            return try konteksto!.executeFetchRequest(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    static func chiujStiloj() -> [NSManagedObject]? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest()
        serchPeto.entity = NSEntityDescription.entityForName("Stilo", inManagedObjectContext: konteksto!)
        do {
            return try konteksto!.executeFetchRequest(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    static func chiujMallongigoj() -> [NSManagedObject]? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest()
        serchPeto.entity = NSEntityDescription.entityForName("Mallongigo", inManagedObjectContext: konteksto!)
        do {
            return try konteksto!.executeFetchRequest(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    // Serchi specifajn objektojn ======================
    
    static func lingvoPorKodo(kodo: String) -> NSManagedObject? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest()
        serchPeto.entity = NSEntityDescription.entityForName("Lingvo", inManagedObjectContext: konteksto!)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto!.executeFetchRequest(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    static func artikoloPorIndekso(indekso: String) -> NSManagedObject? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest()
        serchPeto.entity = NSEntityDescription.entityForName("Artikolo", inManagedObjectContext: konteksto!)
        serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])
        do {
            return try konteksto!.executeFetchRequest(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
}