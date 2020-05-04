//
//  InformojPaghoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

/*
    Informoj pri la programo, kaj ligoj al samtemaj retpaghoj
*/
class InformojPaghoViewController: UIViewController, Stilplena {
    
    @IBOutlet var rulumilo: UIScrollView?
    @IBOutlet var fonoView: UIView?
    @IBOutlet var linioView: UIView?
    @IBOutlet var etikedo: TTTAttributedLabel?
    
    var titolo: String?
    var teksto: String?
    
    init(titolo: String, teksto: String) {
        self.titolo = titolo
        self.teksto = teksto
        super.init(nibName: "InformojPaghoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        guard let teksto = teksto else { return }
        
        title = titolo
        
        etikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        etikedo?.text = teksto
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
        
        guard let titolo = titolo else { return }
        
        parent?.title = NSLocalizedString(titolo, comment: "")
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    func efektivigiStilon() {
        
        view.backgroundColor = UzantDatumaro.stilo.fonKoloro
        rulumilo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        fonoView?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        linioView?.layer.borderWidth = 1
        linioView?.layer.borderColor = UzantDatumaro.stilo.fonKoloro.cgColor
        linioView?.backgroundColor = UzantDatumaro.stilo.bazKoloro
        
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
        etikedo?.linkAttributes = [kCTForegroundColorAttributeName : UzantDatumaro.stilo.tintKoloro, kCTUnderlineStyleAttributeName : NSNumber(value: NSUnderlineStyle.single.rawValue)]
        //etikedo?.activeLinkAttributes = [NSAttributedString.Key.foregroundColor : UzantDatumaro.stilo.tintKoloro, .underlineStyle : NSNumber(value: .single.rawValue)]
    }
}

extension InformojPaghoViewController : TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL?) {
        if let url = url {
            UIApplication.shared.openURL(url)
        }
    }
}

// Respondi al mediaj shanghoj
extension InformojPaghoViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        etikedo?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }
}
