//
//  DatumLegilo.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoDatumbazoOSX

/*
    Chi tiu klaso legas la datumojn faritajn de la Ruby-programeto kaj uzas ilin
    cele al konstrui Core Data datumbazon por posta uzado.
*/
final class DatumLegilo {
  
    static func fariDatumbazon(en konteksto: NSManagedObjectContext, datumoURL: URL, produktajhoURL: URL) {
        
        var lingvoKodoj = [String]()
        let alirilo = DatumbazAlirilo(konteksto: konteksto)
        
        print("Komencas datumbaz-konstruon")
        
        // Enlegi lingvojn
        let lingvoURL = datumoURL.appendingPathComponent("lingvoj.json")
        do {
            print("Legas lingvojn")
            let lingvoDat = try Data(contentsOf: lingvoURL)
            let lingvoJ = try JSONSerialization.jsonObject(with: lingvoDat, options: JSONSerialization.ReadingOptions())
            
            if let listo = lingvoJ as? NSArray {
                
                for lingvo in listo {
                    if let enhavoj = lingvo as? NSArray {
                        
                        let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Lingvo", into: konteksto)
                        novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                        novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                        if let kodo = enhavoj[0] as? String {
                            lingvoKodoj.append(kodo)
                        }
                    }
                }
                
                try konteksto.save()
            }
        } catch {
            print("Erar en kreado de lingvo-datumbaz-objektoj")
        }
        
        // Enlegi fakojn
        let fakoURL = datumoURL.appendingPathComponent("fakoj.json")
        do {
            print("Legas fakojn")
            let fakoDat = try Data(contentsOf: fakoURL)
            let fakoJ = try JSONSerialization.jsonObject(with: fakoDat as Data, options: JSONSerialization.ReadingOptions())
            
            if let listo = fakoJ as? NSArray {
                
                for fako in listo {
                    if let enhavoj = fako as? NSArray {
                        
                        let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Fako", into: konteksto)
                        novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                        novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                    }
                }
                
                try konteksto.save()
            }
        } catch {
            print("Erar en kreado de fako-datumbaz-objektoj")
        }
        
        // Enlegi stilojn
        let stiloURL = datumoURL.appendingPathComponent("stiloj.json")
        do {
            print("Legas stilojn")
            let stiloDat = try Data(contentsOf: stiloURL)
            let stiloJ = try JSONSerialization.jsonObject(with: stiloDat as Data, options: JSONSerialization.ReadingOptions())
            
            if let listo = stiloJ as? NSArray {
                
                for stilo in listo {
                    if let enhavoj = stilo as? NSArray {
                        
                        let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Stilo", into: konteksto)
                        novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                        novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                    }
                }
                
                try konteksto.save()
            }
        } catch {
            print("Erar en kreado de stilo-datumbaz-objektoj")
        }
        
        // Enlegi mallongigojn
        let mallongigoURL = datumoURL.appendingPathComponent("mallongigoj.json")
        do {
            print("Legas mallongigojn")
            let mallongigoDat = try Data(contentsOf: mallongigoURL)
            let mallongigoJ = try JSONSerialization.jsonObject(with: mallongigoDat as Data, options: JSONSerialization.ReadingOptions())
            
            if let listo = mallongigoJ as? NSArray {
                
                for mallongigo in listo {
                    if let enhavoj = mallongigo as? NSArray {
                        
                        let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Mallongigo", into: konteksto)
                        novaObjekto.setValue(enhavoj[0], forKey: "kodo")
                        novaObjekto.setValue(enhavoj[1], forKey: "nomo")
                    }
                }
                
                try konteksto.save()
            }
        } catch {
            print("Erar en kreado de mallongigo-datumbaz-objektoj")
        }
        
        // Enlegi artikolojn
        let artikoloURL = datumoURL.appendingPathComponent("vortoj.json")
        do {
            print("Legas artikolojn")
            let artikoloDat = try Data(contentsOf: artikoloURL)
            let artikoloJ = try JSONSerialization.jsonObject(with: artikoloDat as Data, options: JSONSerialization.ReadingOptions())
            
            if let listo = artikoloJ as? NSArray {
                
                var artikoloNumero = 0
                
                for artikolo in listo {
                    if let enhavoj = artikolo as? NSDictionary {
                        
                        let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Artikolo", into: konteksto)
                        
                        novaObjekto.setValue(artikoloNumero, forKey: "numero")
                        artikoloNumero += 1
                        novaObjekto.setValue(enhavoj["titolo"], forKey: "titolo")
                        novaObjekto.setValue(enhavoj["radiko"], forKey: "radiko")
                        novaObjekto.setValue(enhavoj["indekso"], forKey: "indekso")
                        let tradukDatumoj = try JSONSerialization.data(withJSONObject: enhavoj["tradukoj"]!, options: JSONSerialization.WritingOptions())
                        novaObjekto.setValue(tradukDatumoj, forKey: "tradukoj")
                        let vortDatumoj = try JSONSerialization.data(withJSONObject: enhavoj["objekto"]!, options: JSONSerialization.WritingOptions())
                        novaObjekto.setValue(vortDatumoj, forKey: "vortoj")
                    }
                }
                
                try konteksto.save()
            }
        } catch {
            print("Erar en kreado de artikolo-datumbaz-objektoj")
        }
        
        // Enlegi fakojvortojn
        let fakvortoURL = datumoURL.appendingPathComponent("fakvortoj.json")
        do {
            print("Legas fakvortojn")
            let fakvortojDat = try Data(contentsOf: fakvortoURL)
            let fakvortojJSON = try JSONSerialization.jsonObject(with: fakvortojDat as Data, options: JSONSerialization.ReadingOptions())
            
            if let fakoj = fakvortojJSON as? NSDictionary {
                for (fako, vortoj) in fakoj as? [String: [String: [AnyObject]] ] ?? [:] {
                    for (_, datumoj) in vortoj {
                        
                        let vortDatumoj = datumoj.first!
                        
                        let nomo = vortDatumoj["nomo"] as? String
                        let teksto = vortDatumoj["teksto"] as? String
                        let indekso = vortDatumoj["indekso"] as? String
                        let marko = vortDatumoj["marko"] as? String
                        let senco = vortDatumoj["senco"] as! Int
                        
                        let novaDestino = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
                        novaDestino.setValue(teksto, forKey: "teksto")
                        novaDestino.setValue(indekso, forKey: "indekso")
                        novaDestino.setValue(nomo, forKey: "nomo")
                        novaDestino.setValue(marko, forKey: "marko")
                        novaDestino.setValue(String(senco), forKey: "senco")
                        if let artikolo = alirilo.artikoloPorIndekso(indekso!) {
                            novaDestino.setValue(artikolo, forKey: "artikolo")
                            if let fako = alirilo.fakoPorKodo(fako) {
                                fako.mutableSetValue(forKey: "fakvortoj").add(novaDestino)
                            }
                        }
                    }
                }
                
                try konteksto.save()
            }
        } catch {
            print("Erar en kreado de fako-datumbaz-objektoj")
        }
        
        let trieFarilo = TrieFarilo(konteksto: konteksto, datumoURL: datumoURL)
        trieFarilo.konstruiChiuTrie(kodoj: lingvoKodoj)
        
        TekstFarilo.fariTekstoDosieron(alirilo, produktajhoURL: produktajhoURL)
        
        print("Finis datumbaz-konstruadon")
    }
}
