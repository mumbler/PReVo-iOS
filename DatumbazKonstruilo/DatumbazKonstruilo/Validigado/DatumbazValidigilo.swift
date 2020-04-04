//
//  DatumbazValidigilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 4/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

final class DatumbazValidigilo {
    static func validas(konteksto: NSManagedObjectContext) -> Bool {
        
        var validas = true
        
        print("Komencas validigadon")
        
        let objektoj = ["Lingvo", "Fako", "Stilo", "Mallongigo", "Artikolo"]
        for objekto in objektoj {
            do {
                let peto = NSFetchRequest<NSManagedObject>(entityName: objekto)
                peto.includesSubentities = false
                let kvanto = try konteksto.count(for: peto)
                
                if kvanto > 0 {
                    print("Trovis \(kvanto) \(objekto)j")
                } else {
                    print("ERARO: trovis nul \(objekto)j")
                    validas = false
                }
                
            } catch let error as NSError {
                print("Eraro okazis en validigado de \(objekto)j")
                print(error)
            }
        }
        
        print("Finis validigadon")
        
        return validas
    }
}
