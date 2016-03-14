//
//  ChefaNavigationController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit
import iOS_Slide_Menu

let flankMenuoLargheco: CGFloat = 180

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
    
    func montriArtikolon(artikolo: Artikolo) {
        
        montriArtikolon(artikolo, marko: nil)
    }
    
    func montriArtikolon(artikolo: Artikolo, marko: String?) {
        
        if let veraMarko = marko {
            pushViewController(ArtikoloViewController(enartikolo: artikolo, enmarko: veraMarko)!, animated: true)
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
            subLinio?.frame = CGRectMake(0, navigationBar.frame.size.height - 1, navigationBar.frame.size.width, 1)
        }
        subLinio?.backgroundColor = UzantDatumaro.stilo.SubLinioKoloro
        
        for filo in childViewControllers {
            if let konforma = filo as? Stilplena {
                konforma.efektivigiStilon()
            }
        }
    }

}

extension ChefaNavigationController {
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}
