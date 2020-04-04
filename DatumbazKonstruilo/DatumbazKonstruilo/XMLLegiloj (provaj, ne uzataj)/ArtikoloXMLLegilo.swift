//
//  ArtikoloXMLLegilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 3/16/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

class ArtikoloXMLLegilo: NSObject, XMLParserDelegate {
    
    private let konteksto: NSManagedObjectContext
    
    
    init(_ konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {

    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

    }
}

// MARK: - Vokilo

extension ArtikoloXMLLegilo {
    
    public static func legiDosierujon(_ ujoURL: URL, radikoURL: String, enKontekston konteksto: NSManagedObjectContext) -> [String] {
        
        // Enlegi literojn
        print("Eklegas literojn")
        if let literoURL = Bundle.main.url(forResource: radikoURL + "cfg/literoj", withExtension: "xml") {
            let literoj = LiteroXMLLegilo.legiDosieron(literoURL, enKontekston: konteksto)
            print("Finis literolegadon. Trovis X literojn.")
        } else {
            print("Eraro: ne trovis litero-dosieron")
        }
        
        do {
            let artikoloURLoj = try FileManager.default.contentsOfDirectory(at: ujoURL,
                                                                            includingPropertiesForKeys: nil,
                                                                            options: .skipsSubdirectoryDescendants)
                                              
            print("Trovis \(artikoloURLoj.count) artikolojn")
            for artikoloURL in artikoloURLoj {
                let artikoloLegilo = ArtikoloXMLLegilo(konteksto)
                if let parser = XMLParser(contentsOf: artikoloURL) {
                    parser.delegate = artikoloLegilo
                    parser.parse()
                }
            }
            
            return ["OK"]
        } catch {
            print("Eraro: Ne trovis artikol-dosierujon")
        }
        
        return [String]()
    }
}
