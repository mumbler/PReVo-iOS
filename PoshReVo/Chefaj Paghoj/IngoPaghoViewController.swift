//
//  ChefaPaghoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import iOS_Slide_Menu

/*
    Protocol por la enhavitaj paghoj. Tiu chi funkcio helpas ilin pritigi la
    navigacian tabulon lau siaj proproaj bezonoj
*/
protocol Chefpagho {
    
    func aranghiNavigaciilo() -> Void
}

/*
    Enum kiu reprezentas la elektojn de la maldekstra menuo. Kiam la uzanto premas
    unu el tiuj butonoj, la elekto reprezentighas per unu el chi tiuj valoroj.
*/
enum Pagho : Int {
    case Serchi = 0, Historio, Konservitaj, Agordoj, Pri
    
    var nomo: String {
        
        switch self {
        case .Serchi:
            return NSLocalizedString("flanko serchi etikedo", comment: "")
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

/*
    La ingo pagho estas la baza ekrano de la programo. Kiam alia chefa pagho, ekzemple sercha,
    historia, ktp. montrighos, fakte la ingo pagho nur intershanghas siajn enhavojn. Tiu ebligas
    ke la montrita pagho shanghighas ech kiam alia pagho sidas sure - ekzemple, ni povos forigi
    artikolan paghon kaj malkashi ian ajn paghon sube, ne nur tio kiu estis sube antau.
*/
class IngoPaghoViewController : UIViewController, Stilplena {
    
    @IBOutlet var nunaEkrano: UIView?
    var filoVC: UIViewController?
    var filoV: UIView?
    
    init() {
        super.init(nibName: "IngoPaghoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
    }
    
    // Montri paghon de tiu speco.
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
            novaPagho = PriViewController()
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
    
    func efektivigiStilon() {
        
        if let konforma = filoVC as? Stilplena {
            
            konforma.efektivigiStilon()
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
