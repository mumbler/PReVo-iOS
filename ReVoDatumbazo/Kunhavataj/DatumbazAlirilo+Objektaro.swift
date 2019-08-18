//
//  DatumbazAlirilo+Objektaro.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

extension DatumbazAlirilo {
    
    public func chiujLingvoj() -> [NSManagedObject]? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
        do {
            return try konteksto.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    public func chiujFakoj() -> [NSManagedObject]? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
        do {
            return try konteksto.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    public func chiujStiloj() -> [NSManagedObject]? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Stilo", in: konteksto)
        do {
            return try konteksto.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
    
    public func chiujMallongigoj() -> [NSManagedObject]? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Mallongigo", in: konteksto)
        do {
            return try konteksto.fetch(serchPeto) as? [NSManagedObject]
        } catch { }
        
        return nil
    }
}
