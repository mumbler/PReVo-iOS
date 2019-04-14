//
//  DatumLegilo.swift
//  PoshReVo
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
        
        var lingvoKodoj = [String]()
        
        // Enlegi lingvojn
        if let lingvoURL = Bundle.main.url(forResource: "lingvoj", withExtension: "dat") {
            do {
                let lingvoDat = try Data(contentsOf: lingvoURL)
                let lingvoJ = try JSONSerialization.jsonObject(with: lingvoDat, options: JSONSerialization.ReadingOptions())
                
                if let listo = lingvoJ as? NSArray {
                    
                    for lingvo in listo {
                        if let enhavoj = lingvo as? NSArray {
                            
                            let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Lingvo", into: konteksto!)
                            novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                            novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            if let kodo = enhavoj[0] as? String {
                                lingvoKodoj.append(kodo)
                            }
                        }
                    }
                    
                    try konteksto?.save()
                }
            } catch {
                NSLog("Erar en kreado de lingvo-datumbaz-objektoj")
            }
        }
        
        // Enlegi fakojn
        if let fakoURL = Bundle.main.url(forResource: "fakoj", withExtension: "dat") {
            do {
                let fakoDat = try Data(contentsOf: fakoURL)
                let fakoJ = try JSONSerialization.jsonObject(with: fakoDat as Data, options: JSONSerialization.ReadingOptions())
                
                if let listo = fakoJ as? NSArray {
                    
                    for fako in listo {
                        if let enhavoj = fako as? NSArray {
                            
                            let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Fako", into: konteksto!)
                            novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                            novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                        }
                    }
                    
                    try konteksto?.save()
                }
            } catch {
                NSLog("Erar en kreado de fako-datumbaz-objektoj")
            }
        }
        
        // Enlegi stilojn
        if let stiloURL = Bundle.main.url(forResource: "stiloj", withExtension: "dat") {
            do {
                let stiloDat = try Data(contentsOf: stiloURL)
                let stiloJ = try JSONSerialization.jsonObject(with: stiloDat as Data, options: JSONSerialization.ReadingOptions())
                
                if let listo = stiloJ as? NSArray {
                    
                    for stilo in listo {
                        if let enhavoj = stilo as? NSArray {
                            
                            let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Stilo", into: konteksto!)
                            novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                            novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                        }
                    }
                    
                    try konteksto?.save()
                }
            } catch {
                NSLog("Erar en kreado de stilo-datumbaz-objektoj")
            }
        }
        
        // Enlegi mallongigojn
        if let mallongigoURL = Bundle.main.url(forResource: "mallongigoj", withExtension: "dat") {
            do {
                let mallongigoDat = try Data(contentsOf: mallongigoURL)
                let mallongigoJ = try JSONSerialization.jsonObject(with: mallongigoDat as Data, options: JSONSerialization.ReadingOptions())
                
                if let listo = mallongigoJ as? NSArray {
                    
                    for mallongigo in listo {
                        if let enhavoj = mallongigo as? NSArray {
                            
                            let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Mallongigo", into: konteksto!)
                            novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                            novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                        }
                    }
                    
                    try konteksto?.save()
                }
            } catch {
                NSLog("Erar en kreado de mallongigo-datumbaz-objektoj")
            }
        }
        
        // Enlegi artikolojn
        if let artikoloURL = Bundle.main.url(forResource: "vortoj", withExtension: "dat") {
            do {
                let artikoloDat = try Data(contentsOf: artikoloURL)
                let artikoloJ = try JSONSerialization.jsonObject(with: artikoloDat as Data, options: JSONSerialization.ReadingOptions())
                
                if let listo = artikoloJ as? NSArray {
                    
                    for artikolo in listo {
                        if let enhavoj = artikolo as? NSDictionary {
                            
                            let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Artikolo", into: konteksto!)
                            novaObjekto.setValue(enhavoj["titolo"], forKey: "titolo")
                            novaObjekto.setValue(enhavoj["radiko"], forKey: "radiko")
                            novaObjekto.setValue(enhavoj["indekso"], forKey: "indekso")
                            let tradukDatumoj = try JSONSerialization.data(withJSONObject: enhavoj["tradukoj"]!, options: JSONSerialization.WritingOptions())
                            novaObjekto.setValue(tradukDatumoj, forKey: "tradukoj")
                            let vortDatumoj = try JSONSerialization.data(withJSONObject: enhavoj["objekto"]!, options: JSONSerialization.WritingOptions())
                            novaObjekto.setValue(vortDatumoj, forKey: "vortoj")
                        }
                    }
                    
                    try konteksto?.save()
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
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto!)
        do {
            return try konteksto!.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    static func chiujFakoj() -> [NSManagedObject]? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto!)
        do {
            return try konteksto!.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    static func chiujStiloj() -> [NSManagedObject]? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Stilo", in: konteksto!)
        do {
            return try konteksto!.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    static func chiujMallongigoj() -> [NSManagedObject]? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Mallongigo", in: konteksto!)
        do {
            return try konteksto!.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    // Serchi specifajn objektojn ======================
    
    static func lingvoPorKodo(_ kodo: String) -> NSManagedObject? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto!)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto!.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    static func artikoloPorIndekso(_ indekso: String) -> NSManagedObject? {
        
        if konteksto == nil {
            return nil
        }
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto!)
        serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])
        do {
            return try konteksto!.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
}
