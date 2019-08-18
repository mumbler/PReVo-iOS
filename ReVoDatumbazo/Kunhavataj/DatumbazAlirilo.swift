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
        
        /*NSFetchRequest *myRequest = [[NSFetchRequest alloc] init];
         [myRequest setEntity: [NSEntityDescription entityForName:myEntityName inManagedObjectContext:myManagedObjectContext]];
         NSError *error = nil;
         NSUInteger myEntityCount = [myManagedObjectContext countForFetchRequest:myRequest error:&error];
         [myRequest release];*/
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "PK == %@", argumentArray: [2])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
        
    }

}
