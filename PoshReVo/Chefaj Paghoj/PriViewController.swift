//
//  PriViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

/*
    Informoj pri la programo, kaj ligoj al samtemaj retpaghoj
*/
class PriViewController : UIViewController, Chefpagho, Stilplena {
    
    @IBOutlet var rulumilo: UIScrollView?
    @IBOutlet var etikedo: TTTAttributedLabel?
    
    init() {
        super.init(nibName: "PriViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("pri titolo", comment: "")
        let versioTeksto = String(format: NSLocalizedString("pri versio", comment: ""), arguments: [ (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "" ])
        let teksto = NSLocalizedString("pri teksto", comment: "") + "\n\n" + versioTeksto
        etikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        
        etikedo?.delegate = self
        
        efektivigiStilon()
        let markoj = Iloj.troviMarkojn(teksto: teksto)
        etikedo?.setText(Iloj.pretigiTekston(teksto, kunMarkoj: markoj))
        for ligMarko in markoj[markoLigoKlavo]! {
            etikedo?.addLink( to: URL(string: ligMarko.2), with: NSMakeRange(ligMarko.0, ligMarko.1 - ligMarko.0) )
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    func aranghiNavigaciilo() {
        
        parent?.title = NSLocalizedString("pri titolo", comment: "")
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    func efektivigiStilon() {
        
        rulumilo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        view.backgroundColor = UzantDatumaro.stilo.bazKoloro
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        etikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
        //etikedo?.activeLinkAttributes = [NSAttributedString.Key.foregroundColor : UzantDatumaro.stilo.tintKoloro, .underlineStyle : NSNumber(value: .single.rawValue)]
    }
}

extension PriViewController : TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL?) {
        if let url = url {
            UIApplication.shared.openURL(url)
        }
    }
}

// Respondi al mediaj shanghoj
extension PriViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        etikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }
}
