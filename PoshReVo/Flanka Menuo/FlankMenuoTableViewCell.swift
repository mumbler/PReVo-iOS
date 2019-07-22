//
//  FlankMenuoTableViewCell.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

class FlankMenuoTableViewCell : UITableViewCell {

    @IBOutlet var etikedo: UILabel?
    @IBOutlet var bildo: UIImageView?
    
    func prepari(teksto: String, bildoNomo: String) {

        etikedo?.text = teksto
        bildo?.image = UIImage(named:bildoNomo)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        contentView.backgroundColor = UzantDatumaro.stilo.flankFonKoloro
        etikedo?.textColor = UzantDatumaro.stilo.flankTekstKoloro
        bildo?.tintColor = UzantDatumaro.stilo.flankTekstKoloro
        
        let elektitaView = UIView()
        elektitaView.backgroundColor = UzantDatumaro.stilo.flankElektitaKoloro
        selectedBackgroundView = elektitaView
    }
}
