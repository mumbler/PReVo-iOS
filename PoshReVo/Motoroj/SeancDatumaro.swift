//
//  SeancDatumaro.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoDatumbazo

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
        
        for lingvo in DatumbazAlirilo.komuna.chiujLingvoj() ?? [] {
            
            if let kodo = lingvo.value(forKey: "kodo") as? String,
               let nomo = lingvo.value(forKey: "nomo") as? String {
                
                if kodo == "eo" {
                    lingvoj.append(esperantaLingvo())
                } else {
                    lingvoj.append( Lingvo(kodo, nomo) )
                }
            }
        }
        lingvoj.sort { (unua: Lingvo, dua: Lingvo) -> Bool in
            return unua.nomo.compare(dua.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
        }
        
        for fako in DatumbazAlirilo.komuna.chiujFakoj() ?? [] {
            
            if let kodo = fako.value(forKey: "kodo") as? String,
               let nomo = fako.value(forKey: "nomo") as? String {
                fakoj.append( Fako(kodo, nomo) )
            }
            
            fakoj.sort { (unua: Fako, dua: Fako) -> Bool in
                return unua.nomo.compare(dua.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
            }
        }

        for stilo in DatumbazAlirilo.komuna.chiujStiloj() ?? [] {
            
            if let kodo = stilo.value(forKey: "kodo") as? String,
               let nomo = stilo.value(forKey: "nomo") as? String {
                stiloj.append( Stilo(kodo, nomo) )
            }
        }
        
        for mallongigo in DatumbazAlirilo.komuna.chiujMallongigoj() ?? [] {
            
            if let kodo = mallongigo.value(forKey: "kodo") as? String,
               let nomo = mallongigo.value(forKey: "nomo") as? String {
                mallongigoj.append( Mallongigo(kodo, nomo) )
            }
        }
    }
    
    static func esperantaLingvo() -> Lingvo {
        return Lingvo("eo", "Esperanto")
    }
    
    // Trovo de datumbazeroj -------------------
    
    static func lingvoPorKodo(_ kodo: String) -> Lingvo? {
        
        if let indekso = lingvoj.firstIndex(where: { (nuna: Lingvo) -> Bool in
            return nuna.kodo == kodo
        }) {
            return lingvoj[indekso]
        }
        
        return nil
    }
    
    static func artikoloPorIndekso(_ indekso: String) -> Artikolo? {
        
        if let objekto = DatumbazAlirilo.komuna.artikoloPorIndekso(indekso) {
            return Artikolo(objekto: objekto)
        }
        
        return nil
    }
    
    static func tekstoPorUzo(_ teksto: String, tipo: String)  -> String? {
        
        if tipo == "fak" {
            // Nun ni ne uzas la tutajn fakajn tekstojn. La mallongigoj
            // sufichas
            
            /*if let indekso = fakoj.firstIndex(where: { (nuna: Fako) -> Bool in
                return nuna.kodo == teksto
            }) {
                return "[" + fakoj[indekso].nomo + "]"
            }*/
            return "[" + teksto + "]"
        }
        else if tipo == "stl" {
            if let indekso = stiloj.firstIndex(where: { (nuna: Stilo) -> Bool in
                return nuna.kodo == teksto
            }) {
                return "(" + stiloj[indekso].nomo + ")"
            }
        }
    
        return nil
    }
    
}
