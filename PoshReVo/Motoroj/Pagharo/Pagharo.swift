//
//  Pagharo.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/6/19.
//  Copyright © 2019 Sinuous Rill. All rights reserved.
//

/*
 Enum kiu reprezentas la elektojn de la maldekstra menuo. Kiam la uzanto premas
 unu el tiuj butonoj, la elekto reprezentighas per unu el chi tiuj valoroj.
 */
enum Pagho : Int {
    case Serchi = 0, Esplori, Historio, Konservitaj, Agordoj, Pri
    
    var nomo: String {
        
        switch self {
        case .Serchi:
            return NSLocalizedString("flanko serchi etikedo", comment: "")
        case .Esplori:
            return NSLocalizedString("flanko esplori etikedo", comment: "")
        case .Historio:
            return NSLocalizedString("flanko historio etikedo", comment: "")
        case .Konservitaj:
            return NSLocalizedString("flanko konservitaj etikedo", comment: "")
        case .Agordoj:
            return NSLocalizedString("flanko agordoj etikedo", comment: "")
        case .Pri:
            return NSLocalizedString("flanko pri etikedo", comment: "")
        }
    }
    
    var bildoNomo: String {
        
        switch self {
        case .Serchi:
            return "pikto_lenso"
        case .Esplori:
            return "pikto_kompaso"
        case .Historio:
            return "pikto_libro"
        case .Konservitaj:
            return "pikto_stelo"
        case .Agordoj:
            return "pikto_dentrado"
        case .Pri:
            return "pikto_informo"
        }
    }
    
    static var count: Int { return Pri.rawValue + 1 }
    
}
