//
//  ArtikoloPiedButonoTableViewHeaderFooterView.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class ArtikoloPiedButonoTableViewHeaderFooterView : UITableViewHeaderFooterView {

    @IBOutlet var butono: UIButton?
    
    func prepari() {
        
        butono?.titleLabel?.text = NSLocalizedString("traduk-elektilo butono titolo", comment: "")
        butono?.layer.borderWidth = 1
        butono?.layer.cornerRadius = 9
    }
    
}
