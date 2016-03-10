//
//  SerchPaghoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class SerchPaghoViewController : UIViewController, Subpagho {
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var trovTabelo: UITableView?
    
    override func viewDidLoad() {

    }
    
    func aranghiNavigaciilo() {
        
        parentViewController?.title = "Serchi"
        
        let dekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_menuo"), style: UIBarButtonItemStyle.Plain, target: self, action: "elektiLingvon")
        dekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        parentViewController?.navigationItem.rightBarButtonItem = dekstraButono
    }
}