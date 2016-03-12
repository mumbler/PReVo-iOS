//
//  HelpaNavigationController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class HelpaNavigationController : UINavigationController {

    override func viewDidLoad() {
        
        navigationBar.translucent = false
        
        let maldekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_ikso"), style: UIBarButtonItemStyle.Plain, target: self, action: "forigiSin")
        maldekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        topViewController?.navigationItem.leftBarButtonItem = maldekstraButono
    }
    
    func forigiSin() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
