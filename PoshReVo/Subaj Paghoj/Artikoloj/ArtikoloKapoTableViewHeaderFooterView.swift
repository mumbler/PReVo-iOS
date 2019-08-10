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
    @IBOutlet var fonaView: UIView?
    @IBOutlet var liniaView: UIView?
    
    func prepari() {
        
        etikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body);
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        fonaView?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        liniaView?.layer.borderWidth = 1
        //liniaView?.layer.borderColor = UzantDatumaro.stilo.difinKapFonKoloro.cgColor
        liniaView?.layer.borderColor = UzantDatumaro.stilo.fonKoloro.cgColor
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
    }
}
