//
//  ArtikolChelo.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

class ArtikoloTableViewCell : UITableViewCell {

    @IBOutlet var titolaRegiono: UIView?
    @IBOutlet var titolaEtikedo: UILabel?
    @IBOutlet var chefaEtikedo: UILabel?
    
    func prepari(titolo titolo: String, teksto: String) {
        
        titolaEtikedo?.text = titolo
        chefaEtikedo?.text = teksto
    }
    
}
