//
//  UzantDatumaro.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation

let oftajLimo = 5
let historioLimo = 32

class UzantDatumaro {

    static var serchLingvo: Lingvo = Lingvo("", "")
    static var oftajSerchLingvoj: [Lingvo] = [Lingvo]()
    static var tradukLingvoj: Set<Lingvo> = Set<Lingvo>()
    static var historio: [Listero] = [Listero]()
    static var konservitaj: [Listero] = [Listero]()
    
    static func starigi() {
        
        for kodo in NSLocale.preferredLanguages() {
            
            let bazKodo = kodo.componentsSeparatedByString("-").first
            if let lingvo = SeancDatumaro.lingvoPorKodo(bazKodo ?? kodo) {
                tradukLingvoj.insert(lingvo)
                oftajSerchLingvoj.append(lingvo)
            }
        }
        
        if oftajSerchLingvoj.count > oftajLimo {
            oftajSerchLingvoj = Array(oftajSerchLingvoj.prefix(oftajLimo))
        }
        
        elektisSerchLingvon(SeancDatumaro.esperantaLingvo())
    }
    
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
    }
    
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
    }
    
    static func konserviPaghon(artikolo: Listero) {
        
        konservitaj.append(artikolo)
        konservitaj.sortInPlace({ (unua: Listero, dua: Listero) -> Bool in
            return unua.nomo < dua.nomo
        })
    }
    
    static func malkonserviPaghon(artikolo: Listero) {
        
        if let trovo = konservitaj.indexOf({ (nuna: Listero) -> Bool in
        return nuna.indekso == artikolo.indekso
        }) {
            konservitaj.removeAtIndex(trovo)
        }
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
    
}