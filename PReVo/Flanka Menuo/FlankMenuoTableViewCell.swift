//
//  FlankMenuoTableViewCell.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class FlankMenuoTableViewCell : UITableViewCell {
    
    @IBOutlet var etikedo: UILabel?
    @IBOutlet var bildo: UIImageView?
    
    func prepari(teksto: String, bildoNomo: String) {
    
        etikedo?.text = teksto
        bildo?.image = UIImage(named:bildoNomo)
    }
}
