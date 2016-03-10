//
//  DatumLegilo.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import CoreData

class DatumLegilo {
    
    static var konteksto: NSManagedObjectContext?
    
    static func fariDatumbazon() {
        
        if konteksto == nil {
            return
        }
        
        // Enlegi lingvojn
        if let lingvoDos = NSBundle.mainBundle().pathForResource("lingvoj", ofType: "dat") {
            do {
                if let lingvoDat = NSData(contentsOfFile: lingvoDos) {
                    let lingvoJ = try NSJSONSerialization.JSONObjectWithData(lingvoDat, options: NSJSONReadingOptions())
                    
                    if let listo = lingvoJ as? NSArray {
                        
                        for lingvo in listo {
                            if let enhavoj = lingvo as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Lingvo", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de lingvo-datumbaz-objektoj")
            }
        }
        
        // Enlegi fakojn
        if let fakoDos = NSBundle.mainBundle().pathForResource("fakoj", ofType: "dat") {
            do {
                if let fakoDat = NSData(contentsOfFile: fakoDos) {
                    let fakoJ = try NSJSONSerialization.JSONObjectWithData(fakoDat, options: NSJSONReadingOptions())
                    
                    if let listo = fakoJ as? NSArray {
                        
                        for fako in listo {
                            if let enhavoj = fako as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Fako", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de fako-datumbaz-objektoj")
            }
        }
        
        // Enlegi stilojn
        if let stiloDos = NSBundle.mainBundle().pathForResource("stiloj", ofType: "dat") {
            do {
                if let stiloDat = NSData(contentsOfFile: stiloDos) {
                    let stiloJ = try NSJSONSerialization.JSONObjectWithData(stiloDat, options: NSJSONReadingOptions())
                    
                    if let listo = stiloJ as? NSArray {
                        
                        for stilo in listo {
                            if let enhavoj = stilo as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Stilo", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de stilo-datumbaz-objektoj")
            }
        }
        
        // Enlegi mallongigojn
        if let mallongigoDos = NSBundle.mainBundle().pathForResource("mallongigoj", ofType: "dat") {
            do {
                if let mallongigoDat = NSData(contentsOfFile: mallongigoDos) {
                    let mallongigoJ = try NSJSONSerialization.JSONObjectWithData(mallongigoDat, options: NSJSONReadingOptions())
                    
                    if let listo = mallongigoJ as? NSArray {
                        
                        for mallongigo in listo {
                            if let enhavoj = mallongigo as? NSArray {
                                
                                let novaObjekto = NSEntityDescription.insertNewObjectForEntityForName("Mallongigo", inManagedObjectContext: konteksto!)
                                novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                                novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                            }
                        }
                        
                        try konteksto?.save()
                    }
                }
            } catch {
                NSLog("Erar en kreado de mallongigo-datumbaz-objektoj")
            }
        }
        
    }
}