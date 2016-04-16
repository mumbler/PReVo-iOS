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
    
    let titolo: String, radiko: String, indekso: String, ofc: String?
    let grupoj: [Grupo], tradukoj: [Traduko]
    
    init?(objekto: NSManagedObject) {
        
        let trovTitolo = objekto.valueForKey("titolo") as? String
        let trovRadiko = objekto.valueForKey("radiko") as? String
        let trovIndekso = objekto.valueForKey("indekso") as? String
        if trovTitolo == nil || trovRadiko == nil || trovIndekso == nil {
            titolo = ""
            radiko = ""
            indekso = ""
            ofc = nil
            grupoj = [Grupo]()
            tradukoj = [Traduko]()
            return nil
        }
        
        titolo = trovTitolo!
        radiko = trovRadiko!
        indekso = trovIndekso!
        
        var trovOfc: String? = nil
        var novajGrupoj: [Grupo]? = [Grupo]()
        var novajTradukoj: [Traduko] = [Traduko]()
        do {
            
            if let vortoDatumoj = objekto.valueForKey("vortoj") as? NSData {
                let vortoJ = try NSJSONSerialization.JSONObjectWithData(vortoDatumoj, options: NSJSONReadingOptions())
                if let vortoDict = vortoJ as? NSDictionary {
                    
                    trovOfc = vortoDict["ofc"] as? String
                    
                    for grupo in (vortoDict["grupoj"] as? NSArray) ?? [] {
                        var novajVortoj = [Vorto]()
                        for vorto in (grupo["vortoj"] as? NSArray) ?? [] {
                            if let titolo = vorto["titolo"] as? String,
                               let teksto = vorto["teksto"] as? String,
                               let marko = vorto["marko"] as? String {
                                novajVortoj.append(Vorto(titolo: titolo, teksto: teksto, marko: marko, ofc: vorto["ofc"] as? String))
                            }
                        }
                        
                        let teksto = (grupo["teksto"] as? String) ?? ""
                        novajGrupoj?.append(Grupo(teksto: teksto, vortoj:novajVortoj ))
                    }
                }
            }
            
            // Prepari la tradukojn
            if let tradukDatumoj = objekto.valueForKey("tradukoj") as? NSData {
                let tradukJ = try NSJSONSerialization.JSONObjectWithData(tradukDatumoj, options: NSJSONReadingOptions())
                if let tradukDict = tradukJ as? NSDictionary {
                    for (lingvo, tradukoj) in tradukDict {
                        
                        var teksto: String = ""
                        var montriSencon = false
                        
                        let tradukArr = tradukoj as! NSArray
                        for i in 0 ..< tradukArr.count {
                            
                            let nuna = tradukArr[i] as! NSDictionary
                            let lasta: NSDictionary! = (i > 0) ? tradukArr[i-1] as? NSDictionary : nil
                            if lasta != nil && (lasta["nomo"] as? String) != (nuna["nomo"] as? String) { montriSencon = false}

                            for j in i+1 ..< tradukArr.count {
                                if (tradukArr[i]["nomo"] as? String) != (tradukArr[j]["nomo"] as? String) {
                                    break
                                }
                                else if (tradukArr[i]["senco"] as? Int) != (tradukArr[j]["senco"] as? Int) {
                                    montriSencon = true
                                    break
                                }
                            }
                            
                            if let tradTeksto = tradukArr[i]["teksto"] as? String,
                               let tradNomo = tradukArr[i]["nomo"] as? String,
                               let tradIndekso = tradukArr[i]["indekso"] as? String {
                                
                                if lasta == nil ||
                                   (lasta["nomo"] as? String) != (nuna["nomo"] as? String) ||
                                   (lasta["senco"] as? Int) != (nuna["senco"] as? Int) {
                                        if !teksto.isEmpty { teksto += "; " }
                                        teksto += "<a href=\"" + tradIndekso + "\">" + tradNomo
                                        if montriSencon && (tradukArr[i]["senco"] as? Int) > 0 { teksto += " " + String(tradukArr[i]["senco"] as! Int)}
                                        teksto += "</a>: "
                                } else {
                                    teksto += ", "
                                }
                            
                                teksto += tradTeksto
                            }
                        }
                        
                        teksto += "."
                        if let lingvo = SeancDatumaro.lingvoPorKodo(lingvo as! String) {
                            novajTradukoj.append(Traduko(lingvo: lingvo, teksto: teksto))
                        }
                        
                    }
                }
            }
        } catch {
            grupoj = [Grupo]()
            tradukoj = [Traduko]()
            ofc = nil
            return
        }
        
        ofc = trovOfc
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
    
    let titolo: String, teksto: String, marko: String?, ofc: String?
    
    var kunaTitolo: String {
        if let verOfc = ofc {
            return titolo + Iloj.superLit(verOfc)
        } else {
            return titolo
        }
    }
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
