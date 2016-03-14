//
//  StiloElektiloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/12/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let stiloChelIdent = "stilaChelo"

class StiloElektiloViewController : UIViewController, Stilplena {
    
    @IBOutlet var stiloTabelo: UITableView?
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("stilo-elektilo titolo", comment: "")
        
        stiloTabelo?.delegate = self
        stiloTabelo?.dataSource = self
        stiloTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: stiloChelIdent)

        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        stiloTabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
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
}