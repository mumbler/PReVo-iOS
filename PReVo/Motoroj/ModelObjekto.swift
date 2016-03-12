//
//  ModelObjekto.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import CoreData

class Artikolo {
    
    let titolo: String, radiko: String, indekso: String
    let grupoj: [Grupo], tradukoj: [Traduko]
    
    init?(objekto: NSManagedObject) {
        
        let trovTitolo = objekto.valueForKey("titolo") as? String
        let trovRadiko = objekto.valueForKey("radiko") as? String
        let trovIndekso = objekto.valueForKey("indekso") as? String
        if trovTitolo == nil || trovRadiko == nil || trovIndekso == nil {
            titolo = ""
            radiko = ""
            indekso = ""
            grupoj = [Grupo]()
            tradukoj = [Traduko]()
            return nil
        }
        
        titolo = trovTitolo!
        radiko = trovRadiko!
        indekso = trovRadiko!
        
        var novajGrupoj: [Grupo]? = nil
        var novajTradukoj: [Traduko] = [Traduko]()
        do {
            if let vortDatumoj = objekto.valueForKey("vortoj") as? NSData {
                let vortJ = try NSJSONSerialization.JSONObjectWithData(vortDatumoj, options: NSJSONReadingOptions())
                if let vortDict = vortJ as? NSDictionary {
                    let rezulto = Modeloj.traktiNodon(vortDict)
                    novajGrupoj = rezulto.2
                }
            }
            
            if let tradukDatumoj = objekto.valueForKey("tradukoj") as? NSData {
                let tradukJ = try NSJSONSerialization.JSONObjectWithData(tradukDatumoj, options: NSJSONReadingOptions())
                if let tradukDict = tradukJ as? NSDictionary {
                    for (lingvo, tradukoj) in tradukDict {
                        
                        var teksto: String = ""
                        for traduko in (tradukoj as! NSArray) {
                            
                            if let tradDict = traduko as? NSDictionary {
                                let tradIndekso = tradDict["indekso"] as! String
                                let tradNomo = tradDict["nomo"] as! String
                                let tradTeksto = tradDict["teksto"] as! String
                                teksto += "<a href=\"" + tradIndekso + "\">" + tradNomo + "</a>" + ": " + tradTeksto + "; "
                            }
                        }
                        teksto = teksto.substringToIndex(teksto.startIndex.advancedBy(teksto.characters.count - 2))
                        if let lingvo = SeancDatumaro.lingvoPorKodo(lingvo as! String) {
                            novajTradukoj.append(Traduko(lingvo: lingvo, teksto: teksto))
                        }
                        
                    }
                }
            }
        } catch {
            grupoj = [Grupo]()
            tradukoj = [Traduko]()
            return
        }
        
        grupoj = novajGrupoj ?? [Grupo]()
        tradukoj = novajTradukoj
    }
}

struct Grupo {
    
    let teksto: String, vortoj: [Vorto]
}

struct Vorto {
    
    let titolo: String, teksto: String, marko: String?
}

struct Traduko {
    
    let lingvo: Lingvo, teksto: String
}

class Lingvo {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

func ==(lhs: Lingvo, rhs: Lingvo) -> Bool {
    
    return lhs.kodo == rhs.kodo
}

struct Fako {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

struct Stilo {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

struct Mallongigo {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

struct Listero {
    
    let kodo: String, nomo: String
}

class Modeloj {
    
    static func traktiNodon(nodo: NSDictionary) -> (String?, [Vorto]?, [Grupo]?) {
        
        let tipo = nodo["tipo"] as? String
        let filoj = nodo["filoj"] as? NSArray
        var titolo: String? = nil
        var vortoj: [Vorto] = [Vorto]()
        var grupoj: [Grupo] = [Grupo]()
        var teksto: String = ""
        
        
        if let vspec = nodo["vspec"] as? String {
            teksto += vspec + " "
        }
        
        if let uzoj = nodo["uzo"] as? NSArray {
            
            for uzo in uzoj {
                if let uzString = uzo as? String {
                    if tipo == "snc" || tipo == "subsnc" {
                        teksto += uzString + " "
                    } else {
                        teksto += uzString + "\n"
                    }
                }
            }
        }
        
        if let nodTeksto = nodo["teksto"] as? String {
            teksto += nodTeksto
        }
        
        var filNombro = 1
        
        if let verFiloj = filoj {
        for filo in verFiloj {
        if let filDict = filo as? NSDictionary {
            
            let filTipo = filDict["tipo"] as? String
            if filTipo == "subart" {
                
                var grupTeksto = ""
                if let nombro = (nodo["filNombro"] as? Int) where nombro > 1 {
                    grupTeksto += Iloj.alRomia(filNombro) + ". "
                    filNombro += 1
                }
                let rezulto = traktiNodon(filDict)
                if let novajVortoj = rezulto.1 {
                    grupoj.append( Grupo(teksto: grupTeksto + (rezulto.0 ?? ""), vortoj: novajVortoj) )
                }
            } else if filTipo == "drv" {
                let rezulto = traktiNodon(filDict)
                if let novaVorto = rezulto.1?.first {
                    vortoj.append(novaVorto)
                }
            } else if filTipo == "subdrv" {
                if let nombro = (nodo["filNombro"] as? Int) where nombro > 1 {
                    teksto += Iloj.alLitero(filNombro, true)
                    filNombro += 1
                }
                let rezulto = traktiNodon(filDict)
                if let subaTeksto = rezulto.0 {
                    teksto += subaTeksto + "\n"
                }
                teksto += "\n"
            } else if filTipo == "snc" {
                if !teksto.isEmpty {
                    teksto += "\n\n"
                }
                if let nombro = (nodo["filNombro"] as? Int) where nombro > 1 {
                    teksto += String(filNombro) + ".\n"
                    filNombro += 1
                }
                let rezulto = traktiNodon(filDict)
                if let subaTeksto = rezulto.0 {
                    teksto += subaTeksto
                }
            } else if filTipo == "subsnc" {
                if let nombro = (nodo["filNombro"] as? Int) where nombro > 1 {
                    teksto += Iloj.alLitero(filNombro, false)
                    filNombro += 1
                }
                let rezulto = traktiNodon(filDict)
                if let subaTeksto = rezulto.0 {
                    teksto += subaTeksto
                }
                teksto += "\n"
            } else {
                let rezulto = traktiNodon(filDict)
                if let subaTeksto = rezulto.0 {

                    if filTipo == "rim" {
                        teksto += "\n"
                    }
                    
                    teksto += subaTeksto
                }
                if let subajVortoj = rezulto.1 {
                    vortoj = subajVortoj
                }
                if let subajGrupoj = rezulto.2 {
                    grupoj = subajGrupoj
                }
            }
        }
        }
        }
        
        if tipo == "drv" {
            if let kapo = nodo["kapo"] as? NSDictionary, let titolo = kapo["nomo"] as? String {
                vortoj.append(Vorto(titolo: titolo, teksto: teksto, marko: nodo["mrk"] as? String))
            }
        }
        
        if tipo == "art" && grupoj.count == 0 {
            grupoj.append(Grupo(teksto: "", vortoj: vortoj))
        }
        
        var ret: (String?, [Vorto]?, [Grupo]?) = (nil, nil, nil)
        if !teksto.isEmpty { ret.0 = teksto }
        if vortoj.count > 0 {
            ret.1 = vortoj
        }
        if grupoj.count > 0 {
            ret.2 = grupoj
        }
        
        return ret
    }
}
