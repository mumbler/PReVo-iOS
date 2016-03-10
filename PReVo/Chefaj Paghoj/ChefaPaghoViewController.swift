//
//  ChefaPaghoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

enum Pagho : Int {
    case Serchi = 0, Historio, Konservitaj, Agordoj, Pri
    
    var nomo: String {
        
        switch self {
        case .Serchi:
            return "Serchi"
        case .Historio:
            return "Historio"
        case .Konservitaj:
            return "Konservitaj"
        case .Agordoj:
            return "Agordoj"
        case .Pri:
            return "Pri"
        default:
            return ""
        }
    }
    
    var count: Int { return Pri.rawValue + 1 }
    
}

class ChefaPaghoViewController : UIViewController {
    
    @IBOutlet var nunaEkrano: UIView?
    var filoVC: UIViewController?
    var filoV: UIView?
    
    override func viewDidLoad() {
        
    }
    
    func montriPaghon(paghTipo: Pagho) {
        
        var novaPagho: UIViewController? = nil
        switch paghTipo {
        case .Serchi:
            novaPagho = SerchPaghoViewController()
            break
        case .Historio:
            break
        case .Konservitaj:
            break
        case .Agordoj:
            break
        case .Pri:
            break
        default:
            break
        }
        
        if filoVC == nil || novaPagho.dynamicType != filoVC?.dynamicType {
            filoVC?.removeFromParentViewController()
            filoV?.removeFromSuperview()
            filoVC = novaPagho
            filoV = novaPagho?.view
            addChildViewController(filoVC!)
            view.addSubview(filoV!)
            filoV?.frame = view.frame
        }
    }
    
}
