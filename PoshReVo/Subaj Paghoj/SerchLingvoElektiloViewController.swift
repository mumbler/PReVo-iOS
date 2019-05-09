//
//  SerchLingvoElektiloViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

let serchLingvoElektiloChelIdent = "lingvoElektiloChelo"

/*
    Delegate por ke aliaj paghoj povos reagi al lingvo-elektado
*/
protocol SerchLingvoElektiloDelegate {
    
    func elektisSerchLingvon()
}

/*
    Pagho por elekti la lingvo en kiu serchoj okazos. La unua sekcio montras
    lastaj elektitaj lingvoj, kaj sube videblas chiu lingvo
*/
class SerchLingvoElektiloViewController : UIViewController, Stilplena {
    
    @IBOutlet var lingvoTabelo: UITableView?
    var delegate: SerchLingvoElektiloDelegate?
    
    init() {
        super.init(nibName: "SerchLingvoElektiloViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("serch-elektilo titolo", comment: "")
        lingvoTabelo?.delegate = self
        lingvoTabelo?.dataSource = self
        lingvoTabelo?.register(UITableViewCell.self, forCellReuseIdentifier: serchLingvoElektiloChelIdent)

        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        
        lingvoTabelo?.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        lingvoTabelo?.backgroundColor = UzantDatumaro.stilo.fonKoloro
        lingvoTabelo?.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        lingvoTabelo?.reloadData()
    }
    
    func forigiSin() {
        
        if presentingViewController != nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SerchLingvoElektiloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return UzantDatumaro.oftajSerchLingvoj.count
        } else if section == 1 {
            return SeancDatumaro.lingvoj.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = lingvoTabelo?.dequeueReusableCell(withIdentifier: serchLingvoElektiloChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        if indexPath.section == 0 {
            
            novaChelo.textLabel?.text = UzantDatumaro.oftajSerchLingvoj[indexPath.row].nomo
        } else if indexPath.section == 1 {
            
            novaChelo.textLabel?.text = SeancDatumaro.lingvoj[indexPath.row].nomo
        }
        
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return NSLocalizedString("serch-elektilo lastaj etikedo", comment: "")
        } else if section == 1 {
            return NSLocalizedString("serch-elektilo chiuj etikedo", comment: "")
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
        lingvoTabelo?.deselectRow(at: indexPath, animated: true)
        forigiSin()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// Respondi al mediaj shanghoj
extension SerchLingvoElektiloViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        lingvoTabelo?.reloadData()
    }
}

