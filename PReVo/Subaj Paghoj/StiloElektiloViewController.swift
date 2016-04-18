//
//  StiloElektiloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

let stiloChelIdent = "stilaChelo"

/*
    Pagho por elekti la stilon de la programo
*/
class StiloElektiloViewController : UIViewController, Stilplena {
    
    @IBOutlet var stiloTabelo: UITableView?
    
    init() {
        super.init(nibName: "StiloElektiloViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("stilo-elektilo titolo", comment: "")
        
        stiloTabelo?.delegate = self
        stiloTabelo?.dataSource = self
        stiloTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: stiloChelIdent)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didChangePreferredContentSize(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        stiloTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        stiloTabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
        stiloTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        stiloTabelo?.reloadData()
    }
    
}

extension StiloElektiloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return KolorStilo.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = stiloTabelo?.dequeueReusableCellWithIdentifier(stiloChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        if indexPath.row == UzantDatumaro.stilo.rawValue {
            novaChelo.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            novaChelo.accessoryType = UITableViewCellAccessoryType.None
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.tintColor = UzantDatumaro.stilo.tintKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = KolorStilo(rawValue: indexPath.row)?.nomo
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if UzantDatumaro.stilo.rawValue != indexPath.row {
            let antaua = NSIndexPath(forRow: UzantDatumaro.stilo.rawValue, inSection: 0)
            UzantDatumaro.shanghisStilon(KolorStilo(rawValue: indexPath.row) ?? KolorStilo.Hela)
            tableView.reloadRowsAtIndexPaths([antaua, indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// Respondi al mediaj shanghoj
extension StiloElektiloViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        stiloTabelo?.reloadData()
    }
}
