//
//  DatumbazAlirilo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoModeloj

public final class DatumbazAlirilo {
    
    let konteksto: NSManagedObjectContext
    
    public init(konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    public func lingvaObjektoPorKodo(_ kodo: String) -> NSManagedObject? {
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    public func lingvoPorKodo(_ kodo: String) -> Lingvo? {
        if let objekto = lingvaObjektoPorKodo(kodo) {
            return Lingvo.elDatumbazObjekto(objekto)
        }
        return nil
    }
    
    public func fakaObjektoPorKodo(_ kodo: String) -> NSManagedObject? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    public func fakoPorKodo(_ kodo: String) -> Fako? {
        if let objekto = fakaObjektoPorKodo(kodo) {
            return Fako.elDatumbazObjekto(objekto)
        }
        return nil
    }

    public func artikolaObjektoPorIndekso(_ indekso: String) -> NSManagedObject? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    public func artikoloPorIndekso(_ indekso: String) -> Artikolo? {
        if let objekto = artikolaObjektoPorIndekso(indekso) {
            return Artikolo(objekto: objekto, datumbazAlirilo: self)
        }
        
        return nil
    }

    public func iuAjnArtikolo() -> NSManagedObject? {
        let kvanto = kvantoDeArtikoloj()
        let numero = Int.random(in: 0..<kvanto)
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "numero == %@", argumentArray: [numero])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {}
        
        return nil
    }
    
    // Mark: Privataj
    
    private func kvantoDeArtikoloj() -> Int {
        let kvantoPeto = NSFetchRequest<NSFetchRequestResult>()
        kvantoPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        
        do {
            return try konteksto.count(for: kvantoPeto)
        } catch {}
    
        return 0
    }

}
