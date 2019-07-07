//
//  ArtikoloKapoTableViewHeaderFooterView.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

class ArtikoloKapoTableViewHeaderFooterView : UITableViewHeaderFooterView, Stilplena {
    
    @IBOutlet var etikedo: UILabel?
    
    func prepari() {
        
        etikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body);
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        contentView.backgroundColor = UzantDatumaro.stilo.fonKoloro
        etikedo?.textColor = UzantDatumaro.stilo.fonTekstKoloro
    }
}
