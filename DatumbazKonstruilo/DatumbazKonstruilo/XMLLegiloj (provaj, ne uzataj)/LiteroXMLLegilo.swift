//
//  LiteroXMLLegilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 3/17/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//
import Foundation
import CoreData

class LiteroXMLLegilo: NSObject, XMLParserDelegate {
    
    public var literoj = [String: String]()
    
    private let konteksto: NSManagedObjectContext
    private var atendLiteroj = [String:String]()
    
    init(_ konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "l",
            let nomo = attributeDict["nomo"],
            let kodo = attributeDict["kodo"] {
            
            if kodo.count > 2 && kodo.prefix(2) == "#x" {
                let numero = kodo[kodo.index(kodo.startIndex, offsetBy: 2)...]
                if let intLitero = Int(numero, radix: 16),
                    let scalarLitero = UnicodeScalar(intLitero) {
                    
                    let strLitero = String(scalarLitero)
                    literoj[nomo] = strLitero
                    
                    if let atendata = atendLiteroj[nomo] {
                        literoj[atendata] = strLitero
                        atendLiteroj[nomo] = nil
                    }
                }
            } else {
                let partoj = kodo.split(separator: ";")
                
                if partoj.count == 1 {
                    atendLiteroj[kodo] = nomo
                } else if partoj.count > 1 {
                    var sumo = ""
                    for parto in partoj {
                        if parto == "&amp" { continue }
                        if let trovo = literoj[String(parto)] {
                            sumo += trovo
                        }
                    }
                    literoj[nomo] = sumo
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
}

// MARK: - Vokilo

extension LiteroXMLLegilo {
    
    public static func legiDosieron(_ literoURL: URL, enKontekston konteksto: NSManagedObjectContext) -> [String: String] {
                
        var literoj = [String: String]()
        let literoLegilo = LiteroXMLLegilo(konteksto)
        if let parser = XMLParser(contentsOf: literoURL) {
            parser.delegate = literoLegilo
            parser.parse()
            literoj = literoLegilo.literoj
        }
        
        return literoj
    }
}
