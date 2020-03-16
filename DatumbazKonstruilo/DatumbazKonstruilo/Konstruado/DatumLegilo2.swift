//
//  Konstruilo2.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 3/13/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

import ReVoDatumbazoOSX

/*
    Chi tiu klaso legas la datumojn faritajn de la Ruby-programeto kaj uzas ilin
    cele al konstrui Core Data datumbazon por posta uzado.
*/
final class DatumLegilo2: NSObject, XMLParserDelegate {

    static let revoURLRadiko = "revo/"
    
    static func fariDatumbazon(en konteksto: NSManagedObjectContext) {
        
        var lingvoKodoj = [String]()
        let alirilo = DatumbazAlirilo(konteksto: konteksto)
        
        // Enlegi lingvojn
        print("Eklegas lingvojn")
        if let lingvoURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/lingvoj", withExtension: "xml") {
            lingvoKodoj = LingvoXMLLegilo.legiDosieron(lingvoURL, enKontekston: konteksto)
            print("Finis lingvolegadon. Trovis \(lingvoKodoj.count) lingvojn.")
        } else {
            print("Eraro: ne trovis lingvo-dosieron")
        }
        
        // Enlegi fakojn
        print("Eklegas fakojn")
        if let fakoURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/fakoj", withExtension: "xml") {
            let fakoKodoj = FakoXMLLegilo.legiDosieron(fakoURL, enKontekston: konteksto)
            print("Finis fakolegadon. Trovis \(fakoKodoj.count) fakojn.")
        } else {
            print("Eraro: ne trovis fako-dosieron")
        }
        
        // Enlegi stilojn
        print("Eklegas stilojn")
        if let stiloURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/stiloj", withExtension: "xml") {
            let stiloKodoj = StiloXMLLegilo.legiDosieron(stiloURL, enKontekston: konteksto)
            print("Finis stilolegadon. Trovis \(stiloKodoj.count) stilojn.")
        } else {
            print("Eraro: ne trovis stilo-dosieron")
        }
        
        // Enlegi mallongigojn
        print("Eklegas mallongigojn")
        if let mallongigoURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/mallongigoj", withExtension: "xml") {
            let mallongigoKodoj = MallongigoXMLLegilo.legiDosieron(mallongigoURL, enKontekston: konteksto)
            print("Finis mallongigolegadon. Trovis \(mallongigoKodoj.count) mallongigojn.")
        } else {
            print("Eraro: ne trovis mallongigo-dosieron")
        }
        
        do {
            print("Registras ĉion")
            try konteksto.save()
        } catch {
            print("Eraro en ĉionregistrado")
        }
    }
}
