//
//  ChefaPaghoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit
import iOS_Slide_Menu

/*
    Protocol por la enhavitaj paghoj. Tiu chi funkcio helpas ilin pritigi la
    navigacian tabulon lau siaj propraj bezonoj
*/
protocol Chefpagho {
    
    func aranghiNavigaciilo() -> Void
}

/*
    La ingo pagho estas la baza ekrano de la programo. Kiam alia chefa pagho, ekzemple sercha,
    historia, ktp. montrighos, fakte la ingo pagho nur intershanghas siajn enhavojn. Tiu ebligas
    ke la montrita pagho shanghighas ech kiam alia pagho sidas sure - ekzemple, ni povos forigi
    artikolan paghon kaj malkashi ian ajn paghon sube, ne nur tio kiu estis sube antau.
*/
final class IngoPaghoViewController : UIViewController, Stilplena {
    
    var nunaPagho: Pagho? = nil
    
    init() {
        super.init(nibName: "IngoPaghoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
    }
    
    // Montri paghon de tiu speco.
    public func montriPaghon(_ paghTipo: Pagho) {
        
        let novaPagho = PaghMotoro.komuna.ViewControllerPorPagho(paghTipo: paghTipo)
        
        if nunaPagho != paghTipo {
            
            if let malnovaFilo = children.first {
                malnovaFilo.removeFromParent()
                malnovaFilo.view.removeFromSuperview()
            }
            
            novaPagho.willMove(toParent: self)
            addChild(novaPagho)
            novaPagho.didMove(toParent: self)

            view.addSubview(novaPagho.view)
            view.accessibilityElements = [novaPagho.view!]
            novaPagho.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            
            if let konforma = novaPagho as? Chefpagho {
                konforma.aranghiNavigaciilo()
            }
            
            if let sercha = novaPagho as? SerchPaghoViewController {
                sercha.renovigiSerchon()
            }
        }
    }
    
    func efektivigiStilon() {
        
        if let konforma = children.first as? Stilplena {
            konforma.efektivigiStilon()
        }
    }
}

// MARK: - SlideNavigationControllerDelegate

extension IngoPaghoViewController : SlideNavigationControllerDelegate {
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}

// MARK: - FlankMenuoDelegate

extension IngoPaghoViewController : FlankMenuoDelegate {
    
    func elektisPaghon(novaPagho: Pagho) {
        
        montriPaghon(novaPagho)
        SlideNavigationController.sharedInstance().closeMenu(completion: nil)
    }
}
