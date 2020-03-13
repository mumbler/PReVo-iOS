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
        let lingvoLegilo = LingvoXMLLegilo(konteksto)
        if let lingvoURL = Bundle.main.url(forResource: revoURLRadiko + "cfg/lingvoj", withExtension: "xml") {
            print("Eklegas lingvojn")
            if let parser = XMLParser(contentsOf: lingvoURL) {
                parser.delegate = lingvoLegilo
                parser.parse()
                lingvoKodoj = lingvoLegilo.lingvoKodoj
            }
            print("Finis lingvolegadon. Trovis \(lingvoKodoj.count) lingvojn.")
        } else {
            print("Eraro: ne trovis lingvo-dosieron")
        }
        
        do {
            print("Registras ĉion")
            try konteksto.save()
        } catch {
            print("Eraro en ĉionregistrado")
        }
    }
}
