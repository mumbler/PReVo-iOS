//
//  SerchLingvoElektiloViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit

let serchLingvoElektiloChelIdent = "lingvoElektiloChelo"

protocol SerchLingvoElektiloDelegate {
    
    func elektisSerchLingvon()
}

class SerchLingvoElektiloViewController : UIViewController {
    
    @IBOutlet var lingvoTabelo: UITableView?
    var delegate: SerchLingvoElektiloDelegate?
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("serch-elektilo titolo", comment: "")
        lingvoTabelo?.delegate = self
        lingvoTabelo?.dataSource = self
        lingvoTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: serchLingvoElektiloChelIdent)
        lingvoTabelo?.reloadData()
    }
    
    func forigiSin() {
        
        if presentingViewController != nil {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
}

extension SerchLingvoElektiloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return UzantDatumaro.oftajSerchLingvoj.count
        } else if section == 1 {
            return SeancDatumaro.lingvoj.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = lingvoTabelo?.dequeueReusableCellWithIdentifier(serchLingvoElektiloChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        if indexPath.section == 0 {
            
            novaChelo.textLabel?.text = UzantDatumaro.oftajSerchLingvoj[indexPath.row].nomo
        } else if indexPath.section == 1 {
            
            novaChelo.textLabel?.text = SeancDatumaro.lingvoj[indexPath.row].nomo
        }
        
        return novaChelo
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return NSLocalizedString("serch-elektilo oftaj etikedo", comment: "")
        } else if section == 1 {
            return NSLocalizedString("serch-elektilo chiuj etikedo", comment: "")
        }
        
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var lingvo: Lingvo? = nil
        if indexPath.section == 0 {
            lingvo = UzantDatumaro.oftajSerchLingvoj[indexPath.row]
        } else if indexPath.section == 1 {
            lingvo = SeancDatumaro.lingvoj[indexPath.row]
        }
        
        if let veraLingvo = lingvo {
            UzantDatumaro.elektisSerchLingvon(veraLingvo)
            if delegate != nil {
                delegate?.elektisSerchLingvon()
            }
        }
        
        lingvoTabelo?.deselectRowAtIndexPath(indexPath, animated: true)
        forigiSin()
    }
}
