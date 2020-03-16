//
//  LingvoXMLLegilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 3/13/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

class LingvoXMLLegilo: NSObject, XMLParserDelegate {
    
    public var lingvoKodoj = [String]()
    
    private let konteksto: NSManagedObjectContext
    
    private var nunaLingvo: NSManagedObject?
    private var lingvoNomo: String = ""
    
    init(_ konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "lingvo", let kodo = attributeDict["kodo"] {
            nunaLingvo = NSEntityDescription.insertNewObject(forEntityName: "Lingvo", into: konteksto)
            nunaLingvo?.setValue(kodo, forKey: "kodo")
            lingvoKodoj.append(kodo)
            lingvoNomo = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        lingvoNomo += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "lingvo" {
            if let nunaLingvo = nunaLingvo {
                nunaLingvo.setValue(lingvoNomo, forKey: "nomo")
            }
        }
    }
}

extension LingvoXMLLegilo {
    
    public static func legiDosieron(_ lingvoURL: URL, enKontekston konteksto: NSManagedObjectContext) -> [String] {
                
        var lingvoKodoj = [String]()
        let lingvoLegilo = LingvoXMLLegilo(konteksto)
        if let parser = XMLParser(contentsOf: lingvoURL) {
            parser.delegate = lingvoLegilo
            parser.parse()
            lingvoKodoj = lingvoLegilo.lingvoKodoj
        }
        
        return lingvoKodoj
    }
}
