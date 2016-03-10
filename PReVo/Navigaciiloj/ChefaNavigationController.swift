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

class ChefaNavigationController : UINavigationController, SlideNavigationControllerDelegate {
    
    override func viewDidLoad() {
        
        
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
