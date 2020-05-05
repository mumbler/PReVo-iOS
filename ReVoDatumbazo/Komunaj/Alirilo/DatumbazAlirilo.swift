//
//  DatumbazAlirilo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

final public class DatumbazAlirilo {
    
    static var komuna: DatumbazAlirilo?
    
    let konteksto: NSManagedObjectContext
    
    public init(konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    public func lingvoPorKodo(_ kodo: String) -> NSManagedObject? {
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    public func fakoPorKodo(_ kodo: String) -> NSManagedObject? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }

    public func artikoloPorIndekso(_ indekso: String) -> NSManagedObject? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
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
