//
//  PriViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

class PriViewController : UIViewController, Stilplena {
    
    @IBOutlet var etikedo: TTTAttributedLabel?
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("pri titolo", comment: "")
        let teksto = NSLocalizedString("pri teksto", comment: "")
        
        let markoj = Iloj.troviMarkojn(teksto)
        etikedo?.text = Iloj.forigiAngulojn(teksto)
        etikedo?.delegate = self
        
        efektivigiStilon()
        
        let tekstGrandeco = CGFloat(16.0)
        let fortaTeksto = UIFont.boldSystemFontOfSize(tekstGrandeco)
        let akcentaTeksto = UIFont.italicSystemFontOfSize(tekstGrandeco)
        
        etikedo?.setText(Iloj.forigiAngulojn(teksto), afterInheritingLabelAttributesAndConfiguringWithBlock: { (mutaciaTeksto: NSMutableAttributedString!) -> NSMutableAttributedString! in
            
            for akcentMarko in markoj[markoAkcentoKlavo]! {
                mutaciaTeksto.addAttribute(kCTFontAttributeName as String, value: akcentaTeksto, range: NSMakeRange(akcentMarko.0, akcentMarko.1 - akcentMarko.0))
            }
            
            for fortMarko in markoj[markoFortoKlavo]! {
                mutaciaTeksto.addAttribute(kCTFontAttributeName as String, value: fortaTeksto, range: NSMakeRange(fortMarko.0, fortMarko.1 - fortMarko.0))
            }
            
            return mutaciaTeksto
        })
        
        for ligMarko in markoj[markoLigoKlavo]! {
            etikedo?.addLinkToURL( NSURL(string: ligMarko.2), withRange: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0) )
        }
    }
    
    func efektivigiStilon() {
        
        view.backgroundColor = UzantDatumaro.stilo.bazKoloro
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        etikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)]
        etikedo?.activeLinkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)]
    }
}

extension PriViewController : TTTAttributedLabelDelegate {
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        
        let teksto = url.absoluteString
        if teksto == "::MIT" {
            navigationController?.pushViewController(LicencoViewController(), animated: true)
        } else {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}