//
//  FlankMenuoTableViewCell.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

class FlankMenuoTableViewCell : UITableViewCell {

    @IBOutlet var titoloLabel: UILabel!
    @IBOutlet var bildoImageView: UIImageView!
    
    func prepari(teksto: String, bildo: UIImage?) {

        titoloLabel.text = teksto
        bildoImageView.image = bildo?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        efektivigiStilon()
    }
    
    // MARK: - Stilplena
    
    func efektivigiStilon() {
        
        backgroundColor = UzantDatumaro.stilo.flankFonKoloro
        contentView.backgroundColor = UzantDatumaro.stilo.flankFonKoloro
        titoloLabel.textColor = UzantDatumaro.stilo.flankTekstKoloro
        bildoImageView.tintColor = UzantDatumaro.stilo.flankTekstKoloro
        
        let elektitaView = UIView()
        elektitaView.backgroundColor = UzantDatumaro.stilo.flankElektitaKoloro
        selectedBackgroundView = elektitaView
    }
}
