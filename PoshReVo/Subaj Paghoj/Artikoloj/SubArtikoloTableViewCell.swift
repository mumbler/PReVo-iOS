//
//  SubArtikoloCheloTableViewCell.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/23/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

final class SubArtikoloTableViewCell : UITableViewCell, Stilplena {
    
    @IBOutlet var supraConstraint: NSLayoutConstraint?
    @IBOutlet var interConstraint: NSLayoutConstraint?
    @IBOutlet var titolaAltecConstraint: NSLayoutConstraint?
    @IBOutlet var chefaAltecConstraint: NSLayoutConstraint?
    
    @IBOutlet var fonaView: UIView?
    @IBOutlet var liniaView: UIView?
    @IBOutlet var titolaEtikedo: UILabel?
    @IBOutlet var chefaEtikedo: TTTAttributedLabel?
    
    var subart: Bool = false
    
    func prepari(titolo: String?, teksto: String?, unua: Bool = false) {
        
        if let titolo = titolo {
            titolaAltecConstraint?.isActive = false
            titolaEtikedo?.text = titolo
            titolaEtikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body);
        } else {
            titolaAltecConstraint?.isActive = true
        }
        
        if let teksto = teksto {
            chefaEtikedo?.text = Iloj.forigiAngulojn(teksto: teksto)
            chefaAltecConstraint?.isActive = false
            
            let markoj = Iloj.troviMarkojn(teksto: teksto)
            chefaEtikedo?.setText(Iloj.pretigiTekston(teksto, kunMarkoj: markoj))
            
            for ligMarko in markoj[markoLigoKlavo]! {
                chefaEtikedo?.addLink( to: URL(string: ligMarko.2), with: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0) )
            }
        }
        else {
            chefaAltecConstraint?.isActive = true
        }
        
        if titolo != nil && teksto != nil {
            interConstraint?.constant = 4
        } else {
            interConstraint?.constant = 0
        }
        
        if unua {
            supraConstraint?.constant = 4
        }
        else {
            supraConstraint?.constant = 24
        }
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        titolaEtikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        chefaEtikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        backgroundColor = .clear
        fonaView?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        liniaView?.layer.borderWidth = 1
        liniaView?.layer.borderColor = UzantDatumaro.stilo.difinKapFonKoloro.cgColor
        
        chefaEtikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
        chefaEtikedo?.activeLinkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
    }
    
}
