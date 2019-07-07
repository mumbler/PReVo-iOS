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
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var lingvoTabelo: UITableView?
    
    var filtritajLingvoj: [Lingvo]? = nil
    
    var oftajLingvoj: [Lingvo] {
        return UzantDatumaro.oftajSerchLingvoj
    }
    
    var chiujLingvoj: [Lingvo] {
        return filtritajLingvoj ?? SeancDatumaro.lingvoj
    }
    
    var delegate: SerchLingvoElektiloDelegate?
    
    init() {
        super.init(nibName: "SerchLingvoElektiloViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("serch-elektilo titolo", comment: "")
        
        serchTabulo?.delegate = self
        
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

extension SerchLingvoElektiloViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let teksto = searchBar.text else {
            return true
        }
        
        // Ĉapeli literojn
        if UzantDatumaro.serchLingvo == SeancDatumaro.esperantaLingvo()
            && text == "x"
            && teksto.count > 0 {
            
            let chapelita = Iloj.chapeliFinon(teksto)
            if chapelita != teksto {
                searchBar.text = chapelita
                self.searchBar(searchBar, textDidChange: teksto)
                return false
            }
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.text = searchBar.text?.lowercased()
    
        if let teksto = searchBar.text, !teksto.isEmpty {
            filtritajLingvoj = Iloj.filtriLingvojn(teksto: teksto, lingvoj: SeancDatumaro.lingvoj)
        }
        else {
            filtritajLingvoj = nil
        }
        
        lingvoTabelo?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
}

extension SerchLingvoElektiloViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if filtritajLingvoj == nil {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filtritajLingvoj = filtritajLingvoj {
            return filtritajLingvoj.count
        }
        else {
            if section == 0 {
                return oftajLingvoj.count
            } else if section == 1 {
                return chiujLingvoj.count
            }
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
        
        let lingvo: Lingvo
        if let filtritajLingvoj = filtritajLingvoj {
            lingvo = filtritajLingvoj[indexPath.row]
        }
        else {
            if indexPath.section == 0 {
                lingvo = oftajLingvoj[indexPath.row]
            } else {
                lingvo = chiujLingvoj[indexPath.row]
            }
        }
        
        novaChelo.textLabel?.text = lingvo.nomo
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if filtritajLingvoj == nil {
            if section == 0 {
                return NSLocalizedString("serch-elektilo lastaj etikedo", comment: "")
            } else if section == 1 {
                return NSLocalizedString("serch-elektilo chiuj etikedo", comment: "")
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var lingvo: Lingvo? = nil
        if let filtritajLingvoj = filtritajLingvoj {
            lingvo = filtritajLingvoj[indexPath.row]
        }
        else {
            if indexPath.section == 0 {
                lingvo = oftajLingvoj[indexPath.row]
            } else if indexPath.section == 1 {
                lingvo = chiujLingvoj[indexPath.row]
            }
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

