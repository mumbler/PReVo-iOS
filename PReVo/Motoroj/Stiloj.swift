//
//  Stiloj.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

enum KolorStilo : Int {
    case Hela = 0, Malhela
    
    var nomo: String {
        switch self {
        case .Hela:
            return NSLocalizedString("stilo hela nomo", comment: "")
        case .Malhela:
            return NSLocalizedString("stilo malhela nomo", comment: "")
        }
    }
    
    var tekstColoro: UIColor {
        switch self {
        case .Hela:
            return Koloro.Nigro.valoro
        case .Malhela:
            return Koloro.HelaGrizo.valoro
        }
    }
    
    static var count: Int {
        return Malhela.rawValue + 1
    }
}

class Stiloj {
    
}