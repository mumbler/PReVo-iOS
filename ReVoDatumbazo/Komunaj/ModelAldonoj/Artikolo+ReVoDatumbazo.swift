//
//  Artikolo+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/3/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

#if os(iOS)
import ReVoModeloj
#elseif os(macOS)
import ReVoModelojOSX
#endif

extension Artikolo {
    
    static func elDatumbazObjekto(objekto: NSManagedObject, datumbazo: VortaroDatumbazo) -> Artikolo? {
        
        guard let trovTitolo = objekto.value(forKey: "titolo") as? String,
            let trovRadiko = objekto.value(forKey: "radiko") as? String,
            let trovIndekso = objekto.value(forKey: "indekso") as? String else {
           return nil
        }

        var trovOfc: String? = nil
        var novajSubartikoloj: [Subartikolo]? = [Subartikolo]()
        var novajTradukoj: [Traduko] = [Traduko]()
        do {
           
           if let vortoDatumoj = objekto.value(forKey: "vortoj") as? NSData {
               let vortoJ = try JSONSerialization.jsonObject(with: vortoDatumoj as Data, options: JSONSerialization.ReadingOptions())
               if let vortoDict = vortoJ as? NSDictionary {
                   
                   trovOfc = vortoDict["ofc"] as? String
                   
                   for subartikoloj in (vortoDict["grupoj"] as? [[String: Any]]) ?? [[:]] {
                       var novajVortoj = [Vorto]()
                       for vorto in (subartikoloj["vortoj"] as? [[String: Any]]) ?? [[:]] {
                           if let titolo = vorto["titolo"] as? String,
                              let teksto = vorto["teksto"] as? String,
                              let marko = vorto["marko"] as? String {
                                novajVortoj.append(
                                    Vorto(titolo: titolo,
                                          teksto: teksto,
                                          marko: marko,
                                          ofc: vorto["ofc"] as? String
                                    )
                                )
                           }
                       }
                       
                       let teksto = (subartikoloj["teksto"] as? String) ?? ""
                       novajSubartikoloj?.append(Subartikolo(teksto: teksto, vortoj:novajVortoj ))
                   }
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
                       if let lingvoString = lingvo as? String,
                        let lingvo = datumbazo.lingvo(porKodo: lingvoString) {
                           novajTradukoj.append(
                                Traduko(lingvo: lingvo, teksto: teksto)
                           )
                       }
                       
                   }
               }
           }
        } catch {
           return Artikolo(titolo: trovTitolo,
                           radiko: trovRadiko,
                           indekso: trovIndekso,
                           ofc: nil,
                           subartikoloj: [],
                           tradukoj: [])
        }

        return Artikolo(titolo: trovTitolo,
                        radiko: trovRadiko,
                        indekso: trovIndekso,
                        ofc: trovOfc,
                        subartikoloj: novajSubartikoloj ?? [],
                        tradukoj: novajTradukoj)
       
   }
}
