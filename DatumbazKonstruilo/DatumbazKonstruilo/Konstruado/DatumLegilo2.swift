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
        if let lingvoURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/lingvoj", withExtension: "xml") {
            print("Eklegas lingvojn")
            let lingvoLegilo = LingvoXMLLegilo(konteksto)
            if let parser = XMLParser(contentsOf: lingvoURL) {
                parser.delegate = lingvoLegilo
                parser.parse()
                lingvoKodoj = lingvoLegilo.lingvoKodoj
            }
            print("Finis lingvolegadon. Trovis \(lingvoKodoj.count) lingvojn.")
        } else {
            print("Eraro: ne trovis lingvo-dosieron")
        }
        
        // Enlegi fakojn
        if let fakoURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/fakoj", withExtension: "xml") {
            print("Eklegas fakojn")
            let fakoLegilo = FakoXMLLegilo(konteksto)
            if let parser = XMLParser(contentsOf: fakoURL) {
                parser.delegate = fakoLegilo
                parser.parse()
            }
            print("Finis fakolegadon. Trovis \(fakoLegilo.fakoKvanto) fakojn.")
        } else {
            print("Eraro: ne trovis fako-dosieron")
        }
        
        // Enlegi stilojn
        if let stiloURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/stiloj", withExtension: "xml") {
            print("Eklegas stilojn")
            let stiloLegilo = StiloXMLLegilo(konteksto)
            if let parser = XMLParser(contentsOf: stiloURL) {
                parser.delegate = stiloLegilo
                parser.parse()
            }
            print("Finis stilolegadon. Trovis \(stiloLegilo.stiloKvanto) stilojn.")
        } else {
            print("Eraro: ne trovis stilo-dosieron")
        }
        
        // Enlegi mallongigojn
        if let mallongigoURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/mallongigoj", withExtension: "xml") {
            print("Eklegas mallongigojn")
            let mallongigoLegilo = MallongigoXMLLegilo(konteksto)
            if let parser = XMLParser(contentsOf: mallongigoURL) {
                parser.delegate = mallongigoLegilo
                parser.parse()
            }
            print("Finis mallongigolegadon. Trovis \(mallongigoLegilo.mallongigoKvanto) mallongigojn.")
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
