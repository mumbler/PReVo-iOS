//
//  LicencoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

/*
    Pagho por montri la MIT permesilon
*/
class LicencoViewController : UIViewController, Stilplena {
    
    @IBOutlet var etikedo: UILabel?
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("licenco titolo", comment: "")
        etikedo?.text = NSLocalizedString("licenco teksto", comment: "")
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        view.backgroundColor = UzantDatumaro.stilo.bazKoloro
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
    }
}
