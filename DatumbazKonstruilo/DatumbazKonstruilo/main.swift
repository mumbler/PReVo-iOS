//
//  main.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoDatumbazoOSX

let datumbazNomo = "PoshReVoDatumbazo"

var managedObjectModel: NSManagedObjectModel = {
    let datumbazBundle = Bundle(identifier: "inthescales.ReVoDatumbazoOSX")!
    let modelURL = datumbazBundle.url(forResource: "PoshReVoDatumoj", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
}()

var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    let docsUrl = Bundle.main.bundleURL.appendingPathComponent(datumbazNomo + ".sqlite")
    
    do {
        let pragmas: [String : String] = ["journal_mode" : "DELETE", "synchronous" : "OFF"]
        do {
            // Forigi malnovan datumbazon
            try FileManager.default.removeItem(at: docsUrl)
        } catch { }
        let options = [NSSQLitePragmasOption : pragmas]
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: docsUrl, options: options)
    } catch {
        // Report any error we got.
        var dict = [String: Any]()
        dict[NSLocalizedDescriptionKey] = "Malsukcesis sharghante je datumoj"
        dict[NSLocalizedFailureReasonErrorKey] = "Eraro sharghante je datumoj"
        dict[NSUnderlyingErrorKey] = error as NSError
        
        abort()
    }
    
    return coordinator
}()

var managedObjectContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    return managedObjectContext
}()

// ================================================================================================

print("Ekkonstruas datumbazon")
DatumLegilo.fariDatumbazon(en: managedObjectContext)
