//
//  ModelObjekto.swift
//  PoshReVo
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
        
        let trovTitolo = objekto.value(forKey: "titolo") as? String
        let trovRadiko = objekto.value(forKey: "radiko") as? String
        let trovIndekso = objekto.value(forKey: "indekso") as? String
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
            
            if let vortoDatumoj = objekto.value(forKey: "vortoj") as? NSData {
                let vortoJ = try JSONSerialization.jsonObject(with: vortoDatumoj as Data, options: JSONSerialization.ReadingOptions())
                if let vortoDict = vortoJ as? NSDictionary {
                    
                    trovOfc = vortoDict["ofc"] as? String
                    
                    /*for grupo in (vortoDict["grupoj"] as? [[String: Any]]) ?? [:] {
                        var novajVortoj = [Vorto]()
                        for vorto in (grupo["vortoj"] as? [String: Any]) ?? [:] {
                            if let titolo = vorto["titolo"] as? String,
                               let teksto = vorto["teksto"] as? String,
                               let marko = vorto["marko"] as? String {
                                novajVortoj.append(Vorto(titolo: titolo, teksto: teksto, marko: marko, ofc: vorto["ofc"] as? String))
                            }
                        }
                        
                        let teksto = (grupo["teksto"] as? String) ?? ""
                        novajGrupoj?.append(Grupo(teksto: teksto, vortoj:novajVortoj ))
                    }*/
                }
            }
            
            // Prepari la tradukojn
            if let tradukDatumoj = objekto.value(forKey: "tradukoj") as? NSData {
                let tradukJ = try JSONSerialization.jsonObject(with: tradukDatumoj as Data, options: JSONSerialization.ReadingOptions())
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
                                let nunnuna = tradukArr[j] as! NSDictionary
                                if (nuna["nomo"] as? String) != (nunnuna["nomo"] as? String) {
                                    break
                                }
                                else if (nuna["senco"] as? Int) != (nunnuna["senco"] as? Int) {
                                    montriSencon = true
                                    break
                                }
                            }
                            
                            if let tradTeksto = nuna["teksto"] as? String,
                               let tradNomo = nuna["nomo"] as? String,
                               let tradIndekso = nuna["indekso"] as? String {
                                
                                if lasta == nil ||
                                   (lasta["nomo"] as? String) != (nuna["nomo"] as? String) ||
                                   (lasta["senco"] as? Int) != (nuna["senco"] as? Int) {
                                        if !teksto.isEmpty { teksto += "; " }
                                        teksto += "<a href=\"" + tradIndekso + "\">" + tradNomo
                                        if montriSencon && (nuna["senco"] as! Int) > 0 { teksto += " " + String(nuna["senco"] as! Int)}
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
        if let enkodo = aDecoder.decodeObject(forKey: "kodo") as? String,
            let ennomo = aDecoder.decodeObject(forKey: "nomo") as? String {
           self.init(enkodo, ennomo)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(kodo, forKey: "kodo")
        aCoder.encode(nomo, forKey: "nomo")
    }
    
    static func ==(lhs: Lingvo, rhs: Lingvo) -> Bool {
        
        return lhs.kodo == rhs.kodo
    }
    
    override var hash: Int {
        return kodo.hashValue
    }
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
        if let ennomo = aDecoder.decodeObject(forKey: "nomo") as? String,
            let enindekso = aDecoder.decodeObject(forKey: "indekso") as? String {
            self.init(ennomo, enindekso)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nomo, forKey: "nomo")
        aCoder.encode(indekso, forKey: "indekso")
    }
}
