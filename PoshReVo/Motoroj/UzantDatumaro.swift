//
//  UzantDatumaro.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

let oftajLimo = 5 // Limo de lingvoj en la "oftaj uzataj serch-lingvoj" listo
let historioLimo = 32 // Limo de artikoloj en la historio-listo

/*
    La UzantDatumaro enhavas datumojn pri la uzado de la programo. Chi tiuj datumoj
    estas konservitaj ke re-uzataj kiam la programo rekomencas.
*/
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
        
        // Se datumoj ne estas trovitaj, starigi bazan informon
        
        // Trovi lingvojn el la aparataj agoroj, kaj uzi ilin
        if oftajSerchLingvoj.count == 0 {
            for kodo in NSLocale.preferredLanguages {
                
                let bazKodo = kodo.components(separatedBy: "-").first
                if let lingvo = SeancDatumaro.lingvoPorKodo(bazKodo ?? kodo) {
                    tradukLingvoj.insert(lingvo)
                    oftajSerchLingvoj.append(lingvo)
                }
            }
            
            konserviTradukLingvojn = true
            konserviDatumojn()
        }
        
        // Esperanto estas la baza serch-lingvo, se alia ne trovighis
        if serchLingvo == nil {
            elektisSerchLingvon(SeancDatumaro.esperantaLingvo())
        } else {
            elektisSerchLingvon(UzantDatumaro.serchLingvo)
        }
        
        if oftajSerchLingvoj.count > oftajLimo {
            oftajSerchLingvoj = Array(oftajSerchLingvoj.prefix(oftajLimo))
        }
        
    }
    
    // Lingvoj --------------
    
    // Uzata post kiam oni elektas serch-lingvon. Ghi ghisdatigas parencajn aferojn
    static func elektisSerchLingvon(_ elektita: Lingvo) {
        
        serchLingvo = elektita
        
        if let indekso = oftajSerchLingvoj.firstIndex(where: { (nuna: Lingvo) -> Bool in
            return nuna.kodo == elektita.kodo
        }) {
            oftajSerchLingvoj.remove(at: indekso)
        }
        
        oftajSerchLingvoj.insert(elektita, at: 0)
        if oftajSerchLingvoj.count > oftajLimo {
            oftajSerchLingvoj = Array(oftajSerchLingvoj.prefix(oftajLimo))
        }
        
        konserviSerchLingvon = true
        konserviOftajnLingvojn = true
        konserviDatumojn()
    }
    
    // Uzata post elekto de traduk-lingvojn. Ghi konservas la novajn.
    static func elektisTradukLingvojn() {
        
        konserviTradukLingvojn = true
        konserviDatumojn()
    }
    
    // Historio -------------
    
    // Uzata kiam oni vizitas artikolon por konservi ghin kaj ghisdatigi
    // la historion
    static func visitisPaghon(_ artikolo: Listero) {
        
        if let trovo = historio.firstIndex(where: { (nuna: Listero) -> Bool in
            nuna.indekso == artikolo.indekso
        }) {
            historio.remove(at: trovo)
        }
        
        historio.insert(artikolo, at: 0)
        
        if historio.count > historioLimo {
            historio = Array(historio.prefix(historioLimo))
        }
        
        konserviHistorion = true
        konserviDatumojn()
    }
    
    static func nuligiHistorion() {

        historio.removeAll()
    
        konserviHistorion = true
        konserviDatumojn()
    }
    
    // Konservado de artikoloj ---------
    
    static func konserviPaghon(_ artikolo: Listero) {
        
        konservitaj.append(artikolo)
        konservitaj.sort(by: { (unua: Listero, dua: Listero) -> Bool in
            return unua.nomo < dua.nomo
        })
        
        konserviKonservitajn = true
        konserviDatumojn()
    }
    
    static func malkonserviPaghon(_ artikolo: Listero) {
        
        if let trovo = konservitaj.firstIndex(where: { (nuna: Listero) -> Bool in
            return nuna.indekso == artikolo.indekso
        }) {
            konservitaj.remove(at: trovo)
        }
        
        konserviKonservitajn = true
        konserviDatumojn()
    }
    
    // Konservi au malkonservi lausituacio
    static func shanghiKonservitecon(artikolo: Listero) {
        
        if !konservitaj.contains(where: {(unua: Listero) -> Bool in
            return unua.indekso == artikolo.indekso
        }) {
            konserviPaghon(artikolo)
        } else {
            malkonserviPaghon(artikolo)
        }
    }
    
    static func nuligiKonservitajn() {
        konservitaj.removeAll()
        
        konserviKonservitajn = true
        konserviDatumojn()
    }
    
    // Stiloj -----------
    
    static func shanghisStilon(novaStilo: KolorStilo) {
        
        stilo = novaStilo
        Stiloj.efektivigiStilon(novaStilo)
        
        konserviStilon = true
        konserviDatumojn()
    }
    
    // Konservado kaj resharghado de datumoj ---------------------------
    
    // Konservi la uzant datumojn por reuzi ghin post rekomenco de la programo
    static func konserviDatumojn() {
        
        let defaults = UserDefaults.standard
        
        if konserviSerchLingvon {
            let datumoj = NSKeyedArchiver.archivedData(withRootObject: serchLingvo)
            defaults.set(datumoj, forKey: "serchLingvo")
            konserviSerchLingvon = false
        }
        
        if konserviOftajnLingvojn {
            let datumoj = NSKeyedArchiver.archivedData(withRootObject: oftajSerchLingvoj)
            defaults.set(datumoj, forKey: "oftajSerchLingvoj")
            konserviOftajnLingvojn = false
        }
        
        if konserviTradukLingvojn {
            let datumoj = NSKeyedArchiver.archivedData(withRootObject: Array(tradukLingvoj))
            defaults.set(datumoj, forKey: "tradukLingvoj")
            konserviTradukLingvojn = false
        }
        
        if konserviHistorion {
            let datumoj = NSKeyedArchiver.archivedData(withRootObject: historio)
            defaults.set(datumoj, forKey: "historio")
            konserviHistorion = false
        }
        
        if konserviKonservitajn {
            let datumoj = NSKeyedArchiver.archivedData(withRootObject: konservitaj)
            defaults.set(datumoj, forKey: "konservitaj")
            konserviKonservitajn = false
        }
        
        if konserviStilon {
            defaults.set(stilo.rawValue, forKey: "stilo")
            konserviStilon = false
        }
        
        defaults.synchronize()
    }
    
    // Trovi kaj starigi jamajn datumojn pri uzado
    static func sharghiJeKonservitajnDatumojn() {
        
        let defaults = UserDefaults.standard
        
        // Legi malnov-nomajn aferojn
        NSKeyedUnarchiver.setClass(Lingvo.self, forClassName: "PReVo.Lingvo")
        NSKeyedUnarchiver.setClass(Listero.self, forClassName: "PReVo.Listero")
        
        if let datumoj = defaults.object(forKey: "serchLingvo") as? Data,
            let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? Lingvo {
            serchLingvo = trovo
        }
        
        if let datumoj = defaults.object(forKey: "oftajSerchLingvoj") as? Data,
            let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Lingvo] {
            oftajSerchLingvoj = trovo
        }
        
        if let datumoj = defaults.object(forKey: "tradukLingvoj") as? Data,
            let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Lingvo] {
            tradukLingvoj = Set<Lingvo>(trovo)
        }
        
        if let datumoj = defaults.object(forKey: "historio") as? Data,
            let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Listero] {
            historio = trovo
        }
        
        if let datumoj = defaults.object(forKey: "konservitaj") as? Data,
            let trovo = NSKeyedUnarchiver.unarchiveObject(with: datumoj) as? [Listero] {
            konservitaj = trovo
        }
        
        stilo = KolorStilo(rawValue: defaults.integer(forKey: "stilo")) ?? KolorStilo.Hela
    }
}
