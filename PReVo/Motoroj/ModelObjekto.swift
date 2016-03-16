//
//  ModelObjekto.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import CoreData

/*
    Objektoj kiuj reprezentas la enhavojn de la datumbazon, kaj kiu estas uzata de la pli antaua flanko
    de la programo.
*/

/*
    Artikolo reprezentas la enhavoj de unu artikolo pagho.
    "grupoj" spegulas la sub-artikoloj de la retejo - la plejparto de artikoloj
    havas nur unu grupo, sed kelkaj havas pli. La chi tie tradukoj estas tiuj
    kiuj aperas en la artikolo
*/
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
        indekso = trovIndekso!
        
        var novajGrupoj: [Grupo]? = nil
        var novajTradukoj: [Traduko] = [Traduko]()
        do {
            if let vortDatumoj = objekto.valueForKey("vortoj") as? NSData {
                let vortJ = try NSJSONSerialization.JSONObjectWithData(vortDatumoj, options: NSJSONReadingOptions())
                if let vortDict = vortJ as? NSDictionary {
                    // Fari la grupojn, vortojn, kaj tekstojn de la artikolo
                    let rezulto = Modeloj.traktiNodon(vortDict)
                    novajGrupoj = rezulto.2
                }
            }
            
            // Prepari la tradukojn
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

/*
    Grupo enhavas sian propran tekston, kaj listo de vortoj
    kies teksto aperos sube
*/
struct Grupo {
    
    let teksto: String, vortoj: [Vorto]
}

/*
    Vorto reprezentas unu au pli vortoj kun sama difino.
    Ili estas la bazaj eroj de artikoloj
*/
struct Vorto {
    
    let titolo: String, teksto: String, marko: String?
}

/*
    Traduko aperas en la suba parto de artikolo, kaj montras
    tradukoj en aliajn lingvojn.
*/
struct Traduko {
    
    let lingvo: Lingvo, teksto: String
}

/*
    La lingvo objekto estas uzata por elekti kiun lingvon uzi por
    serchado, kaj kiujn lingvojn montri en la traduka sekcio de
    artikolo
*/
class Lingvo : NSObject, NSCoding {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let enkodo = aDecoder.decodeObjectForKey("kodo") as? String,
           let ennomo = aDecoder.decodeObjectForKey("nomo") as? String {
           self.init(enkodo, ennomo)
        } else {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(kodo, forKey: "kodo")
        aCoder.encodeObject(nomo, forKey: "nomo")
    }
    
    override func isEqual(object: AnyObject?) -> Bool {

        if let konforma = object as? Lingvo {
            return kodo == konforma.kodo
        }
        
        return false
    }
    
    override var hashValue: Int {
        return kodo.hashValue
    }
}

func ==(lhs: Lingvo, rhs: Lingvo) -> Bool {
    
    return lhs.kodo == rhs.kodo
}

// Fakoj aperas en kelkaj difinoj
struct Fako {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

// Stiloj aperas en kelkaj difinoj
struct Stilo {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

// Mallongigoj nun ne uzatas, sed eble estontece
struct Mallongigo {
    
    let kodo: String, nomo: String
    
    init(_ enkodo: String, _ ennomo: String) {
        kodo = enkodo
        nomo = ennomo
    }
}

/* Listero estas ghenerala objekto por reprezenti artikolon en
   liston ekzemple la historio, kaj havas apartan nomon por montri
*/
class Listero : NSObject, NSCoding {
    
    let nomo: String, indekso: String
    
    init(_ ennomo: String, _ enindekso: String) {
        nomo = ennomo
        indekso = enindekso
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let ennomo = aDecoder.decodeObjectForKey("nomo") as? String,
            let enindekso = aDecoder.decodeObjectForKey("indekso") as? String {
            self.init(ennomo, enindekso)
        } else {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(nomo, forKey: "nomo")
        aCoder.encodeObject(indekso, forKey: "indekso")
    }
}

class Modeloj {
    
    /*
        Chi tiu funkcio konstruas la tekstojn de artikoloj. Ghi estas memuzanta, kaj traktas la
        krudajn datumojn kaj faras legeblan tekston el ili.
    */
    static func traktiNodon(nodo: NSDictionary) -> (String?, [Vorto]?, [Grupo]?) {
        
        let tipo = nodo["tipo"] as? String
        let filoj = nodo["filoj"] as? NSArray
        var vortoj: [Vorto] = [Vorto]()
        var grupoj: [Grupo] = [Grupo]()
        var teksto: String = ""
        
        if let vspec = nodo["vspec"] as? String {
            teksto += vspec + " "
        }
        
        if let uzoj = nodo["uzoj"] as? NSArray {
            
            for uzo in uzoj {
                if let enhavoj = uzo as? NSDictionary {
                    
                    if let enteksto = enhavoj["teksto"] as? String,
                       let entipo = enhavoj["tip"] as? String,
                       let uzTeksto = SeancDatumaro.tekstoPorUzo(enteksto, tipo: entipo) {
                        if tipo == "snc" || tipo == "subsnc" {
                            teksto += uzTeksto + " "
                        }
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
                if !(rezulto.0 == nil && rezulto.1 == nil && rezulto.2 == nil) {
                    grupoj.append( Grupo(teksto: grupTeksto + (rezulto.0 ?? ""), vortoj: rezulto.1 ?? []) )
                }
            } else if filTipo == "drv" {
                let rezulto = traktiNodon(filDict)
                if let novaVorto = rezulto.1?.first {
                    vortoj.append(novaVorto)
                }
            } else if filTipo == "subdrv" {
                if !teksto.isEmpty {
                    teksto += "\n\n"
                }
                if let nombro = (nodo["filNombro"] as? Int) where nombro > 1 {
                    teksto += Iloj.alLitero(filNombro - 1, true) + ". "
                    filNombro += 1
                }
                let rezulto = traktiNodon(filDict)
                if let subaTeksto = rezulto.0 {
                    teksto += subaTeksto
                }
            } else if filTipo == "snc" {
                if !teksto.isEmpty {
                    teksto += "\n\n"
                }
                if let nombro = (nodo["filNombro"] as? Int) where nombro > 1 {
                    teksto += String(filNombro) + ". "
                    filNombro += 1
                }
                let rezulto = traktiNodon(filDict)
                if let subaTeksto = rezulto.0 {
                    teksto += subaTeksto
                }
            } else if filTipo == "subsnc" {
                if !teksto.isEmpty {
                    teksto += "\n\n"
                }
                if let nombro = (nodo["filNombro"] as? Int) where nombro > 1 {
                    teksto += Iloj.alLitero(filNombro - 1, false) + ") "
                    filNombro += 1
                }
                let rezulto = traktiNodon(filDict)
                if let subaTeksto = rezulto.0 {
                    teksto += subaTeksto
                }
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
