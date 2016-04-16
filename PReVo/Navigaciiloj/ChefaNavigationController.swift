//
//  ChefaNavigationController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import iOS_Slide_Menu

var flankMenuoLargheco: CGFloat = 180

/*
    La chefa UINavigationControlle de la programo. Ghi starigas la maldekstra-flankan menuon,
    kaj enhavas la chefajn paghojn.
*/
class ChefaNavigationController : SlideNavigationController, Stilplena {
    
    var subLinio: UIView?
    
    override func viewDidLoad() {
        
        navigationBar.translucent = false
        
        let maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_menuo"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SlideNavigationController.toggleLeftMenu))
        maldekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        navigationItem.leftBarButtonItem = maldekstraButono
        leftBarButtonItem = maldekstraButono
        let flankMenuo = FlankMenuoViewController()
        leftMenu = flankMenuo

        let longa = max(view.frame.size.height, view.frame.size.width)
        let mallonga = min(view.frame.size.height, view.frame.size.width)
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            portraitSlideOffset = mallonga * 0.55
            landscapeSlideOffset = longa * 0.75
        } else {
            portraitSlideOffset = mallonga * 0.75
            landscapeSlideOffset = longa * 0.80
        }
        enableSwipeGesture = true
        
        let pagho = IngoPaghoViewController()
        viewControllers.append(pagho)
        flankMenuo.delegate = pagho
        pagho.montriPaghon(Pagho.Serchi)
        
        efektivigiStilon()
    }
    
    // Surpushi artikolan paghon
    func montriArtikolon(artikolo: Artikolo) {
        
        montriArtikolon(artikolo, marko: nil)
    }
    
    // Surpushi artikolan paghon kaj hasti al specifa loko en la artikolo
    func montriArtikolon(artikolo: Artikolo, marko: String?) {
        
        if let veraMarko = marko {
            
            var serchilo = veraMarko
            if let partoj = marko?.componentsSeparatedByString(".") where partoj.count > 2 {
                serchilo = partoj[0] + "." + partoj[1]
            }
            
            pushViewController(ArtikoloViewController(enartikolo: artikolo, enmarko: serchilo)!, animated: true)
        } else {
            pushViewController(ArtikoloViewController(enartikolo: artikolo)!, animated: true)
        }
    }
    
    func efektivigiStilon() {
        
        navigationBar.barTintColor = UzantDatumaro.stilo.navFonKoloro
        navigationBar.tintColor = UzantDatumaro.stilo.navTintKoloro
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UzantDatumaro.stilo.navTekstoKoloro]
        
        if subLinio == nil {
            subLinio = UIView()
            navigationBar.addSubview(subLinio!)
        }
        // Por ke la suba linio staru bone post rotacio
        subLinio?.frame = CGRectMake(0, navigationBar.frame.size.height - 1, navigationBar.frame.size.width, 1)
        subLinio?.backgroundColor = UzantDatumaro.stilo.SubLinioKoloro
        
        for filo in childViewControllers {
            if let konforma = filo as? Stilplena {
                konforma.efektivigiStilon()
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        //subLinio?.hidden = true
        closeMenuWithCompletion(nil)
        
        weak var malforta = self
        
        if coordinator.conformsToProtocol(UIViewControllerTransitionCoordinator) {
            coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            
                if let grandeco = malforta?.navigationBar.frame.size {
                    malforta?.subLinio?.frame = CGRectMake(0, grandeco.height - 1, grandeco.width, 1)
                }
                }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
                    
                malforta?.subLinio?.hidden = false
                if let alteco = malforta?.navigationBar.frame.size.height {
                    (malforta?.leftMenu as? FlankMenuoViewController)?.navAltecoShanghis(alteco)
                }
            }
        }
    }
}
