//
//  StiloXMLLegilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 3/14/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

class StiloXMLLegilo: NSObject, XMLParserDelegate {
    
    public var stiloKodoj = [String]()
    
    private let konteksto: NSManagedObjectContext
    private var nunaStilo: NSManagedObject?
    private var stiloNomo: String = ""
    
    init(_ konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "stilo", let kodo = attributeDict["kodo"] {
            nunaStilo = NSEntityDescription.insertNewObject(forEntityName: "Stilo", into: konteksto)
            nunaStilo?.setValue(kodo, forKey: "kodo")
            stiloKodoj.append(kodo)
            stiloNomo = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        stiloNomo += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "stilo" {
            if let nunaStilo = nunaStilo {
                nunaStilo.setValue(stiloNomo, forKey: "nomo")
            }
        }
    }
}

extension StiloXMLLegilo {
    
    public static func legiDosieron(_ stiloURL: URL, enKontekston konteksto: NSManagedObjectContext) -> [String] {
                
        var stiloKodoj = [String]()
        let stiloLegilo = StiloXMLLegilo(konteksto)
        if let parser = XMLParser(contentsOf: stiloURL) {
            parser.delegate = stiloLegilo
            parser.parse()
            stiloKodoj = stiloLegilo.stiloKodoj
        }
        
        return stiloKodoj
    }
}
