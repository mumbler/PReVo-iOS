//
//  Koloroj.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

/*
    La koloroj uzata de la programo
*/
enum Koloro {
    
    case Nigro, MalhelaGrizo, MezaGrizo, HelaGrizo, KvaraGrizo, HelegaGrizo, Blanko
    case KlasikaVerdo, HelaVerdo, HelegaVerdo
    
    var valoro: UIColor {
        switch self {
        case .Nigro:
            return UIColor.black
        case .MalhelaGrizo:
            return UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        case .MezaGrizo:
            return UIColor(red: 46.0/255.0, green: 46.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        case .HelaGrizo:
            return UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .KvaraGrizo:
            return UIColor(red: 188.0/255.0, green: 186.0/255.0, blue: 193.0/255.0, alpha: 1.0)
        case .HelegaGrizo:
            return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        case .Blanko:
            return UIColor.white
        case .KlasikaVerdo:
            return UIColor(red: 0.0, green: 153.0/255.0, blue: 0.0, alpha: 1.0)
        case .HelaVerdo:
            return UIColor(red: 60.0/255.0, green: 180.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        case .HelegaVerdo:
            return UIColor(red: 60.0/255.0, green: 213.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        }
    }
}
