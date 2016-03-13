//
//  Koloroj.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

enum Koloro {
    
    case Nigro, MalhelaGrizo, MezaGrizo, HelaGrizo, Blanko
    case KlasikaVerdo, HelaVerdo, HelegaVerdo
    
    var valoro: UIColor {
        switch self {
        case Nigro:
            return UIColor.blackColor()
        case .MalhelaGrizo:
            return UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        case .MezaGrizo:
            return UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        case .HelaGrizo:
            return UIColor(red: 140.0/255.0, green: 14.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        case .Blanko:
            return UIColor.whiteColor()
        case .KlasikaVerdo:
            return UIColor(red: 0.0, green: 153.0/255.0, blue: 0.0, alpha: 1.0)
        case .HelaVerdo:
            return UIColor(red: 30.0, green: 183.0/255.0, blue: 30.0, alpha: 1.0)
        case .HelegaVerdo:
            return UIColor(red: 60.0, green: 213.0/255.0, blue: 60.0, alpha: 1.0)
        }
    }
}
