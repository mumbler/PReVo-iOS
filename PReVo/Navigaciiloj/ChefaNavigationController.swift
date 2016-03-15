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

let flankMenuoLargheco: CGFloat = 180

/*
    La chefa UINavigationControlle de la programo. Ghi starigas la maldekstra-flankan menuon,
    kaj enhavas la chefajn paghojn.
*/
class ChefaNavigationController : SlideNavigationController, Stilplena {
    
    var subLinio: UIView?
    
    override func viewDidLoad() {
        
        navigationBar.translucent = false
        
        let maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_menuo"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleLeftMenu")
        maldekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        navigationItem.leftBarButtonItem = maldekstraButono
        leftBarButtonItem = maldekstraButono
        let flankMenuo = FlankMenuoViewController()
        leftMenu = flankMenuo

        portraitSlideOffset = view.frame.size.width - flankMenuoLargheco
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
        subLinio?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
        subLinio?.addConstraint(NSLayoutConstraint(item: subLinio!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 1.0))
        subLinio?.backgroundColor = UzantDatumaro.stilo.SubLinioKoloro
        
        for filo in childViewControllers {
            if let konforma = filo as? Stilplena {
                konforma.efektivigiStilon()
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        subLinio?.hidden = true
        weak var malforta = self
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            malforta?.subLinio?.hidden = false
        });
    }
}
