//
//  ArtikoloPiedButonoTableViewHeaderFooterView.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

class ArtikoloPiedButonoTableViewHeaderFooterView : UITableViewHeaderFooterView, Stilplena {

    @IBOutlet var butono: UIButton?
    @IBOutlet var fono: UIView?
    
    func prepari() {
        
        butono?.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody);
        butono?.titleLabel?.text = NSLocalizedString("traduk-elektilo butono titolo", comment: "")
        butono?.layer.borderWidth = 1
        butono?.layer.cornerRadius = 9
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        fono?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        butono?.titleLabel?.textColor = UzantDatumaro.stilo.tintKoloro
        butono?.layer.borderColor = UzantDatumaro.stilo.tintKoloro.CGColor
    }
    
}
