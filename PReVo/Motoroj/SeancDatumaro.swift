//
//  SeancDatumaro.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import CoreData

/*
    La seancDatumaro enhavas preparitajn datumojn el la datumbazo por rapida
    atingo. Ekzemple la listo de lingvoj, fakoj, ktp.

    Ghi ankau inkluzivas kelkajn funkciojn por facila uzado de tiuj datumoj.
*/
class SeancDatumaro {
    
    static var lingvoj: [Lingvo] = [Lingvo]()
    static var fakoj: [Fako] = [Fako]()
    static var stiloj: [Stilo] = [Stilo]()
    static var mallongigoj: [Mallongigo] = [Mallongigo]()
    
    static func starigi() {
        
        for lingvo in DatumLegilo.chiujLingvoj() ?? [] {
            
            if let kodo = lingvo.valueForKey("kodo") as? String,
               let nomo = lingvo.valueForKey("nomo") as? String {
                
                if kodo == "eo" {
                    lingvoj.append(esperantaLingvo())
                } else {
                    lingvoj.append( Lingvo(kodo, nomo) )
                }
            }
        }
        lingvoj.sortInPlace { (unua: Lingvo, dua: Lingvo) -> Bool in
            return unua.nomo < dua.nomo
        }
        
        for fako in DatumLegilo.chiujFakoj() ?? [] {
            
            if let kodo = fako.valueForKey("kodo") as? String,
               let nomo = fako.valueForKey("nomo") as? String {
                fakoj.append( Fako(kodo, nomo) )
            }
        }

        for stilo in DatumLegilo.chiujStiloj() ?? [] {
            
            if let kodo = stilo.valueForKey("kodo") as? String,
               let nomo = stilo.valueForKey("nomo") as? String {
                stiloj.append( Stilo(kodo, nomo) )
            }
        }
        
        for mallongigo in DatumLegilo.chiujMallongigoj() ?? [] {
            
            if let kodo = mallongigo.valueForKey("kodo") as? String,
               let nomo = mallongigo.valueForKey("nomo") as? String {
                mallongigoj.append( Mallongigo(kodo, nomo) )
            }
        }
    }
    
    static func esperantaLingvo() -> Lingvo {
        return Lingvo("eo", "Esperanto")
    }
    
    // Trovo de datumbazeroj -------------------
    
    static func lingvoPorKodo(kodo: String) -> Lingvo? {
        
        if let indekso = lingvoj.indexOf ({ (nuna: Lingvo) -> Bool in
            return nuna.kodo == kodo
        }) {
            return lingvoj[indekso]
        }
        
        return nil
    }
    
    static func artikoloPorIndekso(indekso: String) -> Artikolo? {
        
        if let objekto = DatumLegilo.artikoloPorIndekso(indekso) {
            return Artikolo(objekto: objekto)
        }
        
        return nil
    }
    
    static func tekstoPorUzo(teksto: String, tipo: String)  -> String? {
        
        if tipo == "fak" {
            // Nun ni ne uzas la tutajn fakajn tekstojn. La mallongigoj
            // sufichas
            
            /*if let indekso = fakoj.indexOf({ (nuna: Fako) -> Bool in
                return nuna.kodo == teksto
            }) {
                return "[" + fakoj[indekso].nomo + "]"
            }*/
            return "[" + teksto + "]"
        }
        else if tipo == "stl" {
            if let indekso = stiloj.indexOf({ (nuna: Stilo) -> Bool in
                return nuna.kodo == teksto
            }) {
                return "(" + stiloj[indekso].nomo + ")"
            }
        }
    
        return nil
    }
    
}