//
//  TekstFarilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 8/24/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation

import ReVoDatumbazoOSX

final class TekstFarilo {

    public static func fariTekstoDosieron(_ alirilo: DatumbazAlirilo, produktajhoURL: URL) {
        
        let teksto = verkiTekstojn(alirilo)    
        let fileURL = produktajhoURL.appendingPathComponent("Generataj.strings")
        
        //writing
        do {
            try teksto.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("Eraro: Ne sukcesis fari generatajn tekstojn.")
        }
        
        //reading
        /*do {
            let teksto = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {/* error handling here */}*/
    }
    
    private static func verkiTekstojn(_ alirilo: DatumbazAlirilo) -> String {
        
        print("Verkas tekstojn")
        
        var teksto = ""
        teksto += verkiKapanTekston()
        teksto += "\n"
        teksto += verkiVortaroMallongiganTekston(alirilo)
        teksto += verkiFakoMallongiganTekston(alirilo)
        return teksto
    }
    
    private static func verkiKapanTekston() -> String {
        var teksto = ""
        teksto += "// Komputile generataj tekstoj\n"
        teksto += "// Ne ŝanĝu mane. Vidu 'TekstFarilo.swift' en DatumbazKonstruilo.\n"
        return teksto
    }
    
    private static func verkiVortaroMallongiganTekston(_ alirilo: DatumbazAlirilo) -> String {
        let mallongigoj = alirilo.chiujMallongigoj()?.sorted(by: { (unua, dua) -> Bool in
            let unuaKodo = (unua.value(forKey: "kodo") as? String) ?? ""
            let duaKodo = (dua.value(forKey: "kodo") as? String) ?? ""
            return unuaKodo.compare(duaKodo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
        })
        
        var teksto = ""
        for mallongigo in mallongigoj ?? [] {
            let kodo = mallongigo.value(forKey: "kodo") as? String
            let nomo = mallongigo.value(forKey: "nomo") as? String
            if let kodo = kodo,
                let nomo = nomo {
                teksto += "<b>" + kodo + "</b>\\\n    " + nomo + "\\\n\n"
            }
        }
        
        return "\"informoj vortaraj-mallongigoj teksto\"\t\t\t= \"" + teksto + "\";\n"
    }
    
    private static func verkiFakoMallongiganTekston(_ alirilo: DatumbazAlirilo) -> String {
        let fakoj = alirilo.chiujFakoj()?.sorted(by: { (unua, dua) -> Bool in
            let unuaKodo = (unua.value(forKey: "kodo") as? String) ?? ""
            let duaKodo = (dua.value(forKey: "kodo") as? String) ?? ""
            return unuaKodo.compare(duaKodo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
        })
        
        var teksto = ""
        for fako in fakoj ?? [] {
            let kodo = fako.value(forKey: "kodo") as? String
            let nomo = fako.value(forKey: "nomo") as? String
            if let kodo = kodo,
                let nomo = nomo {
                teksto += "<b>" + kodo + "</b>\\\n    " + nomo + "\\\n\n"
            }
        }
        
        return "\"informoj fakaj-mallongigoj teksto\"\t\t\t\t= \"" + teksto + "\";\n"
    }
    
}
