//
//  TradukLingvojElektiloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let tradukLingvojElektiloChelIdent = "tradukLingvoElektiloChelo"

protocol TradukLingvojElektiloDelegate {
    
    func elektisTradukLingvojn()
}

class TradukLingvojElektiloViewController : UIViewController {
    
    @IBOutlet var lingvoTabelo: UITableView?
    var eoIndekso: Int = 0
    var delegate: TradukLingvojElektiloDelegate?
    
    override func viewDidLoad() {
        
        eoIndekso = SeancDatumaro.lingvoj.indexOf({ (nuna: Lingvo) -> Bool in
            nuna.kodo == "eo"
        }) ?? 0
        
        title = NSLocalizedString("traduk-elektilo titolo", comment: "")
        lingvoTabelo?.delegate = self
        lingvoTabelo?.dataSource = self
        lingvoTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: tradukLingvojElektiloChelIdent)
        lingvoTabelo?.reloadData()
    }
}

extension TradukLingvojElektiloViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return SeancDatumaro.lingvoj.count - 1
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: TradukLingvojElektiloTableViewCell
        if let trovChelo = lingvoTabelo?.dequeueReusableCellWithIdentifier(tradukLingvojElektiloChelIdent) as? TradukLingvojElektiloTableViewCell {
            novaChelo = trovChelo
        } else {
            novaChelo = TradukLingvojElektiloTableViewCell()
            novaChelo.shaltilo?.tag = indexPath.row
            novaChelo.shaltilo?.addTarget(self, action: "shaltisLingvon:", forControlEvents: UIControlEvents.PrimaryActionTriggered)
        }
        
        if indexPath.section == 0 {
            
            novaChelo.shaltilo?.hidden = true
            switch indexPath.row {
            case 0:
                novaChelo.etikedo?.text = NSLocalizedString("traduk-elektilo chiuj etikedo", comment: "")
                break
            case 1:
                novaChelo.etikedo?.text = NSLocalizedString("traduk-elektilo neniuj etikedo", comment: "")
                break
            default:
                break
            }
        }
        else if indexPath.section == 1 {

            novaChelo.shaltilo?.hidden = false
            let lingvo = SeancDatumaro.lingvoj[indexPath.row + ((indexPath.row <= eoIndekso) ? 0 : 1)]
            novaChelo.etikedo?.text = lingvo.nomo
            
        }
        
        return novaChelo
    }
    
}

// Shaltilo reagado
extension TradukLingvojElektiloViewController {
    
    func shaltilsLingvon(shaltilo: AnyObject) {
        
        
    }
}
