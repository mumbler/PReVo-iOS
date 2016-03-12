//
//  UzantDatumaro.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation

let oftajLimo = 5

class UzantDatumaro {

    static var serchLingvo: Lingvo = Lingvo("", "")
    static var oftajSerchLingvoj: [Lingvo] = [Lingvo]()
    static var tradukLingvoj: [Lingvo] = [Lingvo]()
    //static var historio: [Listero]
    
    static func starigi() {
        
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
}