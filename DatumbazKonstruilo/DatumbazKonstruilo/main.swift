//
//  main.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import ReVoDatumbazoOSX

print("Hello, World!")

DatumLegilo.fariDatumbazon()

/*¯lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let docsUrl = self.applicationDocumentsDirectory.appendingPathComponent(datumbazNomo + ".sqlite")
    let bundleUrl = Bundle.main.url(forResource: datumbazNomo, withExtension: "sqlite")
    
    do {
        let pragmas: [String : String] = ["journal_mode" : "DELETE", "synchronous" : "OFF"]
        if kreiDatumbazon {
            do {
                try FileManager.default.removeItem(at: docsUrl)
            } catch { }
            let options = [NSSQLitePragmasOption : pragmas]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: docsUrl, options: options)
        } else {
            let options = [NSReadOnlyPersistentStoreOption : true, NSSQLitePragmasOption : ["journal_mode" : "DELETE", "synchronous" : "OFF"]] as [String : Any]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: bundleUrl, options: options)
        }
    } catch {
        // Report any error we got.
        var dict = [String: Any]()
        dict[NSLocalizedDescriptionKey] = "Malsukcesis sharghante je datumoj"
        dict[NSLocalizedFailureReasonErrorKey] = "Eraro sharghante je datumoj"
        dict[NSUnderlyingErrorKey] = error as NSError
        
        let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
        abort()
    }
    
    return coordinator
}()*/
