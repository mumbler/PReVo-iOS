//
//  HelpaNavigationController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class HelpaNavigationController : UINavigationController, Stilplena {

    var subLinio: UIView?
    
    override func viewDidLoad() {
        
        navigationBar.translucent = false
        
        let maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_ikso"), style: UIBarButtonItemStyle.Plain, target: self, action: "forigiSin")
        maldekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        topViewController?.navigationItem.leftBarButtonItem = maldekstraButono
        
        efektivigiStilon()
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
    
    func forigiSin() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
