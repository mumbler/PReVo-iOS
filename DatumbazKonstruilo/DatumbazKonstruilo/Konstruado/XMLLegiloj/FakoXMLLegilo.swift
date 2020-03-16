//
//  FakoXMLLegilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 3/14/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

class FakoXMLLegilo: NSObject, XMLParserDelegate {
    
    public var fakoKodoj = [String]()
    
    private let konteksto: NSManagedObjectContext
    private var nunaFako: NSManagedObject?
    private var fakoNomo: String = ""
    
    init(_ konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "fako", let kodo = attributeDict["kodo"] {
            nunaFako = NSEntityDescription.insertNewObject(forEntityName: "Fako", into: konteksto)
            nunaFako?.setValue(kodo, forKey: "kodo")
            fakoKodoj.append(kodo)
            fakoNomo = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        fakoNomo += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "fako" {
            if let nunaFako = nunaFako {
                nunaFako.setValue(fakoNomo, forKey: "nomo")
            }
        }
    }
}

extension FakoXMLLegilo {
    
    public static func legiDosieron(_ fakoURL: URL, enKontekston konteksto: NSManagedObjectContext) -> [String] {
                
        var fakoKodoj = [String]()
        let fakoLegilo = FakoXMLLegilo(konteksto)
        if let parser = XMLParser(contentsOf: fakoURL) {
            parser.delegate = fakoLegilo
            parser.parse()
            fakoKodoj = fakoLegilo.fakoKodoj
        }
        
        return fakoKodoj
    }
}
