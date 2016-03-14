//
//  UzantDatumaro.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let oftajLimo = 5
let historioLimo = 32

class UzantDatumaro {

    static var serchLingvo: Lingvo! = nil
    static var oftajSerchLingvoj: [Lingvo] = [Lingvo]()
    static var tradukLingvoj: Set<Lingvo> = Set<Lingvo>()
    static var historio: [Listero] = [Listero]()
    static var konservitaj: [Listero] = [Listero]()
    static var stilo: KolorStilo = KolorStilo.Hela
    
    static var konserviSerchLingvon: Bool = false
    static var konserviOftajnLingvojn: Bool = false
    static var konserviTradukLingvojn: Bool = false
    static var konserviHistorion: Bool = false
    static var konserviKonservitajn: Bool = false
    static var konserviStilon: Bool = false
    
    static func starigi() {
        
        sharghiJeKonservitajnDatumojn()
        
        if oftajSerchLingvoj.count == 0 || tradukLingvoj.count == 0 {
            for kodo in NSLocale.preferredLanguages() {
                
                let bazKodo = kodo.componentsSeparatedByString("-").first
                if let lingvo = SeancDatumaro.lingvoPorKodo(bazKodo ?? kodo) {
                    tradukLingvoj.insert(lingvo)
                    oftajSerchLingvoj.append(lingvo)
                }
            }
        }
        
        if serchLingvo == nil {
            elektisSerchLingvon(SeancDatumaro.esperantaLingvo())
        }
        
        if oftajSerchLingvoj.count > oftajLimo {
            oftajSerchLingvoj = Array(oftajSerchLingvoj.prefix(oftajLimo))
        }
        
    }
    
    // Lingvoj --------------
    
    static func elektisSerchLingvon(elektita: Lingvo) {
        
        serchLingvo = elektita
        
        if let indekso = oftajSerchLingvoj.indexOf({ (nuna: Lingvo) -> Bool in
            return nuna.kodo == elektita.kodo
        }) {
            oftajSerchLingvoj.removeAtIndex(indekso)
        }
        
        oftajSerchLingvoj.insert(elektita, atIndex: 0)
        if oftajSerchLingvoj.count > oftajLimo {
            oftajSerchLingvoj = Array(oftajSerchLingvoj.prefix(oftajLimo))
        }
        
        konserviSerchLingvon = true
        konserviOftajnLingvojn = true
        konserviDatumojn()
    }
    
    static func elektisTradukLingvojn() {
        
        konserviTradukLingvojn = true
        konserviDatumojn()
    }
    
    // Historio -------------
    
    static func visitisPaghon(artikolo: Listero) {
        
        if let trovo = historio.indexOf({ (nuna: Listero) -> Bool in
            nuna.indekso == artikolo.indekso
        }) {
            historio.removeAtIndex(trovo)
        }
        
        historio.insert(artikolo, atIndex: 0)
        
        if historio.count > historioLimo {
            historio = Array(historio.prefix(historioLimo))
        }
        
        konserviHistorion = true
        konserviDatumojn()
    }
    
    // Konservado de artikoloj ---------
    
    static func konserviPaghon(artikolo: Listero) {
        
        konservitaj.append(artikolo)
        konservitaj.sortInPlace({ (unua: Listero, dua: Listero) -> Bool in
            return unua.nomo < dua.nomo
        })
        
        konserviKonservitajn = true
        konserviDatumojn()
    }
    
    static func malkonserviPaghon(artikolo: Listero) {
        
        if let trovo = konservitaj.indexOf({ (nuna: Listero) -> Bool in
        return nuna.indekso == artikolo.indekso
        }) {
            konservitaj.removeAtIndex(trovo)
        }
        
        konserviKonservitajn = true
        konserviDatumojn()
    }
    
    static func shanghiKonservitecon(artikolo: Listero) {
        
        if !konservitaj.contains({(unua: Listero) -> Bool in
            return unua.indekso == artikolo.indekso
        }) {
            konserviPaghon(artikolo)
        } else {
            malkonserviPaghon(artikolo)
        }
    }
    
    // Stiloj -----------
    
    static func shanghisStilon(novaStilo: KolorStilo) {
        
        stilo = novaStilo
        Stiloj.efektivigiStilon(novaStilo)
        
        konserviStilon = true
        konserviDatumojn()
    }
    
    // Konservado kaj resharghado de datumoj ---------------------------
    
    static func konserviDatumojn() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if konserviSerchLingvon {
            let datumoj = NSKeyedArchiver.archivedDataWithRootObject(serchLingvo)
            defaults.setObject(datumoj, forKey: "serchLingvo")
            konserviSerchLingvon = false
        }
        
        if konserviOftajnLingvojn {
            let datumoj = NSKeyedArchiver.archivedDataWithRootObject(oftajSerchLingvoj)
            defaults.setObject(datumoj, forKey: "oftajSerchLingvoj")
            konserviOftajnLingvojn = false
        }
        
        if konserviTradukLingvojn {
            let datumoj = NSKeyedArchiver.archivedDataWithRootObject(tradukLingvoj)
            defaults.setObject(datumoj, forKey: "tradukLingvoj")
            konserviTradukLingvojn = false
        }
        
        if konserviHistorion {
            let datumoj = NSKeyedArchiver.archivedDataWithRootObject(historio)
            defaults.setObject(datumoj, forKey: "historio")
            konserviHistorion = false
        }
        
        if konserviKonservitajn {
            let datumoj = NSKeyedArchiver.archivedDataWithRootObject(konservitaj)
            defaults.setObject(datumoj, forKey: "konservitaj")
            konserviKonservitajn = false
        }
        
        if konserviStilon {
            defaults.setInteger(stilo.rawValue, forKey: "stilo")
            konserviStilon = false
        }
        
        defaults.synchronize()
    }
    
    static func sharghiJeKonservitajnDatumojn() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let datumoj = defaults.objectForKey("serchLingvo") as? NSData,
           let trovo = NSKeyedUnarchiver.unarchiveObjectWithData(datumoj) as? Lingvo {
            serchLingvo = trovo
        }
        
        if let datumoj = defaults.objectForKey("oftajSerchLingvoj") as? NSData,
            let trovo = NSKeyedUnarchiver.unarchiveObjectWithData(datumoj) as? [Lingvo] {
            oftajSerchLingvoj = trovo
        }
        
        if let datumoj = defaults.objectForKey("tradukLingvoj") as? NSData,
            let trovo = NSKeyedUnarchiver.unarchiveObjectWithData(datumoj) as? Set<Lingvo> {
            tradukLingvoj = trovo
        }
        
        if let datumoj = defaults.objectForKey("historio") as? NSData,
            let trovo = NSKeyedUnarchiver.unarchiveObjectWithData(datumoj) as? [Listero] {
            historio = trovo
        }
        
        if let datumoj = defaults.objectForKey("konservitaj") as? NSData,
            let trovo = NSKeyedUnarchiver.unarchiveObjectWithData(datumoj) as? [Listero] {
            konservitaj = trovo
        }
        
        stilo = KolorStilo(rawValue: defaults.integerForKey("stilo")) ?? KolorStilo.Hela
    }
}
