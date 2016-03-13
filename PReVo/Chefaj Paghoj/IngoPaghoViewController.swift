//
//  ChefaPaghoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit
import iOS_Slide_Menu

protocol Chefpagho {
    
    func aranghiNavigaciilo() -> Void
}

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
        }
    }
    
    var bildoNomo: String {
        
        switch self {
        case .Serchi:
            return "pikto_lenso"
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

class IngoPaghoViewController : UIViewController {
    
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
            novaPagho = HistorioViewController()
            break
        case .Konservitaj:
            novaPagho = KonservitajViewController()
            break
        case .Agordoj:
            novaPagho = AgordojViewController()
            break
        case .Pri:
            break
        }
        
        if filoVC == nil || novaPagho.dynamicType != filoVC?.dynamicType {
            filoVC?.removeFromParentViewController()
            filoV?.removeFromSuperview()
            filoVC = novaPagho
            filoV = novaPagho?.view
            addChildViewController(filoVC!)
            view.addSubview(filoV!)
            filoV?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            
            if let konforma = novaPagho as? Chefpagho {
                konforma.aranghiNavigaciilo()
            }
        }
    }
    
}

extension IngoPaghoViewController : SlideNavigationControllerDelegate {
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}

extension IngoPaghoViewController : FlankMenuoDelegate {
    
    func elektisPaghon(novaPagho: Pagho) {
        
        montriPaghon(novaPagho)
        SlideNavigationController.sharedInstance().closeMenuWithCompletion(nil)
    }
}
