//
//  ChefaNavigationController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import iOS_Slide_Menu

var flankMenuoLargheco: CGFloat = 200

/*
    La chefa UINavigationControlle de la programo. Ghi starigas la maldekstra-flankan menuon,
    kaj enhavas la chefajn paghojn.
*/
class ChefaNavigationController : SlideNavigationController, Stilplena {
    
    var subLinio: UIView?
    
    override func viewDidLoad() {
        
        navigationBar.isTranslucent = false
        
        let butonujo = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

        let menuoButono = UIButton()
        menuoButono.setImage(UIImage(named: "pikto_menuo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        menuoButono.tintColor = UzantDatumaro.stilo.navTintKoloro
        menuoButono.addTarget(self, action: #selector(SlideNavigationController.toggleLeftMenu), for: .touchUpInside)
        
        butonujo.addSubview(menuoButono)
        menuoButono.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButono = UIBarButtonItem(customView: butonujo)
        navigationItem.leftBarButtonItem = barButono
        leftBarButtonItem = barButono
        let flankMenuo = FlankMenuoViewController()
        leftMenu = flankMenuo

        let longa = max(view.frame.size.height, view.frame.size.width)
        let mallonga = min(view.frame.size.height, view.frame.size.width)
        if UIDevice.current.userInterfaceIdiom == .phone {
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
    
    // Surpushi artikolan paghon kaj hasti al specifa loko en la artikolo
    func montriArtikolon(_ artikolo: Artikolo, marko: String? = nil) {
        
        if let veraMarko = marko {
            
            var serchilo = veraMarko
            if let partoj = marko?.components(separatedBy: "."), partoj.count > 2 {
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
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UzantDatumaro.stilo.navTekstoKoloro]
        
        if subLinio == nil {
            subLinio = UIView()
            navigationBar.addSubview(subLinio!)
        }
        // Por ke la suba linio staru bone post rotacio
        subLinio?.frame = CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 1)
        subLinio?.backgroundColor = UzantDatumaro.stilo.SubLinioKoloro
        
        for filo in children {
            if let konforma = filo as? Stilplena {
                konforma.efektivigiStilon()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        //subLinio?.hidden = true
        closeMenu(completion: nil)
        
        weak var malforta = self
        
        if coordinator.conforms(to: UIViewControllerTransitionCoordinator.self) {
            coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
                if let grandeco = malforta?.navigationBar.frame.size {
                    malforta?.subLinio?.frame = CGRect(x: 0, y: grandeco.height - 1, width: grandeco.width, height: 1)
                }
                }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
                    
                    malforta?.subLinio?.isHidden = false
                if let alteco = malforta?.navigationBar.frame.size.height {
                    (malforta?.leftMenu as? FlankMenuoViewController)?.navAltecoShanghis(alteco: alteco)
                }
            }
        }
    }
}
