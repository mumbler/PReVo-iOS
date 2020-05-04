//
//  Pagharo.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/6/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
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
            return NSLocalizedString("flanko informoj etikedo", comment: "")
        }
    }
    
    var bildo: UIImage? {
        
        switch self {
        case .Serchi:
            return UIImage(named: "pikto_lenso")
        case .Esplori:
            return UIImage(named: "pikto_kompaso")
        case .Historio:
            return UIImage(named: "pikto_libro")
        case .Konservitaj:
            return UIImage(named: "pikto_stelo")
        case .Agordoj:
            return UIImage(named: "pikto_dentrado")
        case .Pri:
            return UIImage(named: "pikto_informoj")
        }
    }
    
    static var count: Int { return Pri.rawValue + 1 }
    
}
