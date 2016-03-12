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

class ChefaNavigationController : SlideNavigationController {
    
    override func viewDidLoad() {
        
        navigationBar.translucent = false
        
        let maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_menuo"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleLeftMenu")
        maldekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        navigationItem.leftBarButtonItem = maldekstraButono
        leftBarButtonItem = maldekstraButono
        let flankMenuo = FlankMenuoViewController()
        leftMenu = flankMenuo

        portraitSlideOffset = 150
        enableSwipeGesture = true
        
        let pagho = IngoPaghoViewController()
        viewControllers.append(pagho)
        flankMenuo.delegate = pagho
        pagho.montriPaghon(Pagho.Serchi)
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
    
}

extension ChefaNavigationController {
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}
