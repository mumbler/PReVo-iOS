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

let bazaTitolaAlteco: CGFloat = 35

class ArtikoloTableViewCell : UITableViewCell, Stilplena {

    @IBOutlet var titolaRegiono: UIView?
    @IBOutlet var titolaEtikedo: UILabel?
    @IBOutlet var titolaAlteco: NSLayoutConstraint?
    @IBOutlet var chefaEtikedo: TTTAttributedLabel?
    
    var subart: Bool = false
    
    func prepari(titolo titolo: String, teksto: String, subart: Bool) {
        
        titolaEtikedo?.text = titolo
        chefaEtikedo?.text = Iloj.forigiAngulojn(teksto)
        self.subart = subart
        
        efektivigiStilon()
        
        if subart {
            titolaAlteco?.constant = 0
        } else {
            titolaAlteco?.constant = bazaTitolaAlteco
        }
        
        let markoj = Iloj.troviMarkojn(teksto)
        
        let tekstGrandeco = CGFloat(16.0)
        chefaEtikedo?.font = UIFont.systemFontOfSize(tekstGrandeco)
        let fortaTeksto = UIFont.boldSystemFontOfSize(tekstGrandeco)
        let akcentaTeksto = UIFont.italicSystemFontOfSize(tekstGrandeco)
        
        chefaEtikedo?.setText(Iloj.forigiAngulojn(teksto), afterInheritingLabelAttributesAndConfiguringWithBlock: { (mutaciaTeksto: NSMutableAttributedString!) -> NSMutableAttributedString! in
            
            for akcentMarko in markoj[markoAkcentoKlavo]! {
                mutaciaTeksto.addAttribute(kCTFontAttributeName as String, value: akcentaTeksto, range: NSMakeRange(akcentMarko.0, akcentMarko.1 - akcentMarko.0))
            }

            for fortMarko in markoj[markoFortoKlavo]! {
                mutaciaTeksto.addAttribute(kCTFontAttributeName as String, value: fortaTeksto, range: NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0))
            }
            
            return mutaciaTeksto
        })
        
        for ligMarko in markoj[markoLigoKlavo]! {
            chefaEtikedo?.addLinkToURL( NSURL(string: ligMarko.2), withRange: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0) )
        }
    }
    
    func efektivigiStilon() {
        
        if subart {
            backgroundColor = UzantDatumaro.stilo.fonKoloro
            chefaEtikedo?.textColor = UzantDatumaro.stilo.fonTekstKoloro
        } else {
            backgroundColor = UzantDatumaro.stilo.bazKoloro
            titolaEtikedo?.textColor = UzantDatumaro.stilo.difinKapTekstKoloro
            titolaRegiono?.backgroundColor = UzantDatumaro.stilo.difinKapFonKoloro
            chefaEtikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        }

        chefaEtikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)]
        chefaEtikedo?.activeLinkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)]
    }
    
}
