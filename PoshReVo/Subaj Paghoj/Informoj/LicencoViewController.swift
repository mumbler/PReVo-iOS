//
//  LicencoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Robin Hill. All rights reserved.
//

import Foundation
import UIKit

/*
    Pagho por montri la MIT permesilon
*/
class LicencoViewController : UIViewController, Stilplena {
    
    @IBOutlet var etikedo: UILabel?
    
    init() {
        super.init(nibName: "LicencoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("licenco titolo", comment: "")
        etikedo?.text = NSLocalizedString("licenco teksto", comment: "")
        
        efektivigiStilon()
    }
    
    // MARK: - Stilplena
    
    func efektivigiStilon() {
        
        view.backgroundColor = UzantDatumaro.stilo.bazKoloro
        etikedo?.textColor = UzantDatumaro.stilo.tekstKoloro
    }
}
