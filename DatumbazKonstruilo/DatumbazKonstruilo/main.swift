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

let produktajhejo = Bundle.main.bundleURL.appendingPathComponent("/produktajhoj/")
if FileManager.default.fileExists(atPath: produktajhejo.absoluteString) {
    do {
        try FileManager.default.removeItem(at: produktajhejo)
    } catch {
        print("Ne sukcesis nuligi produktajhan dosierujon");
    }
}

do {
    try FileManager.default.createDirectory(at: produktajhejo, withIntermediateDirectories: true, attributes: nil)
} catch {
    print("Ekkonstruas datumbazon")
}

var managedObjectModel: NSManagedObjectModel = {
    let datumbazBundle = Bundle(identifier: "inthescales.ReVoDatumbazoOSX")!
    let modelURL = datumbazBundle.url(forResource: "PoshReVoDatumoj", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
}()

var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    let docsUrl = Bundle.main.bundleURL.appendingPathComponent("/produktajhoj/" + datumbazNomo + ".sqlite")
    
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

DatumLegilo2.fariDatumbazon(en: managedObjectContext)
print("Finis datumbaz-konstruadon")
