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
        leftMenu = FlankMenuoViewController()

        portraitSlideOffset = 150
        enableSwipeGesture = true
        
        let pagho = IngoPaghoViewController()
        viewControllers.append(pagho)
        pagho.montriPaghon(Pagho.Serchi)
    }
    
    func elektiLingvon() {
        
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
