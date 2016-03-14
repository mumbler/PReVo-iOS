//
//  TradukLingvojElektiloTableViewCell.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

class TradukLingvojElektiloTableViewCell : UITableViewCell, Stilplena {

    @IBOutlet var etikedo: UILabel?
    @IBOutlet var shaltilo: UISwitch?
    
    func prepari() {
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        backgroundColor = UzantDatumaro.stilo.bazKoloro
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        shaltilo?.onTintColor = UzantDatumaro.stilo.tintKoloro
    }
}
