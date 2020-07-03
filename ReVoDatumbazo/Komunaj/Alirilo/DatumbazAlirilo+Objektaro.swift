//
//  DatumbazAlirilo+Objektaro.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoModeloj

extension DatumbazAlirilo {
    
    public func chiujLingvoj() -> [Lingvo] {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
        do {
            if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
                return objektoj.compactMap {
                    Lingvo.elDatumbazObjekto($0)
                }
            }
        } catch { }
        
        return []
    }
    
    public func chiujFakoj() -> [Fako] {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
        do {
            if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
                return objektoj.compactMap {
                    Fako.elDatumbazObjekto($0)
                }
            }
        } catch { }
        
        return []
    }
    
    public func fakVortojPorFako(_ kodo: String) -> [NSManagedObject]? {
        
        if let fako = fakaObjektoPorKodo(kodo) {
            let vortoj = fako.mutableSetValue(forKey: "fakvortoj").allObjects as? [NSManagedObject]
            return vortoj?.sorted(by: { (unua: NSManagedObject, dua: NSManagedObject) -> Bool in
                let unuaNomo = unua.value(forKey: "nomo") as! String
                let duaNomo = dua.value(forKey: "nomo") as! String
                return unuaNomo.compare(duaNomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
            })
        }
        
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
