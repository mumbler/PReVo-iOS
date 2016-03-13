//
//  LicencoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class LicencoViewController : UIViewController {
    
    @IBOutlet var etikedo: UILabel?
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("licenco titolo", comment: "")
        etikedo?.text = NSLocalizedString("licenco teksto", comment: "")
    }
}
