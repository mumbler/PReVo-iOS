//
//  TradukLingvojElektiloTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 Sinuous Rill. All rights reserved.
//

import Foundation
import UIKit

let tradukLingvojElektiloChelIdent = "tradukLingvoElektiloChelo"

/*
    Protocol por ke aliaj paghoj povos reagi al la elekto de traduk-lingvoj
*/
protocol TradukLingvojElektiloDelegate {
    
    func elektisTradukLingvojn()
}

/*
    Pagho por elekti lingvojn en kiu tradukoj por vortoj montrighos.
*/
class TradukLingvojElektiloTableViewController : BazStilaTableViewController {
    
    var delegate: TradukLingvojElektiloDelegate?
    var shanghisLingvojn: Bool = false
    
    var tradukLingvoj = [Lingvo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("traduk-elektilo titolo", comment: "")
        tradukLingvoj = kaptiTradukLingvojn()
        
        let redaktButono = UIBarButtonItem.init(title: "Redakti", style: .plain, target: self, action: #selector(TradukLingvojElektiloTableViewController.premisRedakti(sender:)))
        navigationItem.rightBarButtonItem = redaktButono
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tradukLingvojElektiloChelIdent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    private func kaptiTradukLingvojn() -> [Lingvo] {
        return Array<Lingvo>(UzantDatumaro.tradukLingvoj).sorted { (unua: Lingvo, dua: Lingvo) -> Bool in
            return unua.nomo.compare(dua.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if shanghisLingvojn {
            delegate?.elektisTradukLingvojn()
            UzantDatumaro.elektisTradukLingvojn()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (tradukLingvoj.count > 0) ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return (tradukLingvoj.count > 0) ? tradukLingvoj.count : 1
        }
        else if section == 1 {
            return 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chelo = tableView.dequeueReusableCell(withIdentifier: tradukLingvojElektiloChelIdent) ?? UITableViewCell()
        
        if indexPath.section == 0 && tradukLingvoj.count > 0 {
            chelo.textLabel?.text = tradukLingvoj[indexPath.row].nomo
            chelo.accessoryType = .none
        }
        else {
            chelo.textLabel?.text = NSLocalizedString("traduk-elektilo aldoni-butono titolo", comment: "")
            chelo.accessoryType = .disclosureIndicator
        }
        
        chelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        chelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return chelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aldonSekcio = (tradukLingvoj.count > 0 ) ? 1 : 0
        
        if indexPath.section == aldonSekcio {
            let navigaciilo = HelpaNavigationController()
            let elektilo = LingvoElektiloViewController()
            elektilo.starigi(titolo: NSLocalizedString("lingvo-elektilo titolo", comment: ""),
                             suprajTitolo: NSLocalizedString("lingvo-elektilo serchataj etikedo", comment: ""))
            elektilo.delegate = self
            navigaciilo.viewControllers.append(elektilo)
            self.navigationController?.present(navigaciilo, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (tradukLingvoj.count > 0 && indexPath.section == 0) || indexPath.section == 1 {
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (tradukLingvoj.count > 0 && indexPath.section == 0) {
            return true
        }
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let lingvo = tradukLingvoj[indexPath.row]
            tradukLingvoj.remove(at: indexPath.row)
            UzantDatumaro.tradukLingvoj.remove(lingvo)
            tableView.reloadData()
        }
    }
        
    @objc func premisRedakti(sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

extension TradukLingvojElektiloTableViewController: LingvoElektiloDelegate {
    func elektisLingvon(lingvo: Lingvo) {
        UzantDatumaro.tradukLingvoj.insert(lingvo)
        tradukLingvoj = kaptiTradukLingvojn()
        tableView.reloadData()
    }
}

// Respondi al mediaj shanghoj
extension TradukLingvojElektiloTableViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        tableView.reloadData()
    }
}
