//
//  StiloElektiloViewController.swift
//  PoshReVo
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
        stiloTabelo?.register(UITableViewCell.self, forCellReuseIdentifier: stiloChelIdent)

        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeDidChange(forChildContentContainer:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return KolorStilo.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = stiloTabelo?.dequeueReusableCell(withIdentifier: stiloChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        if indexPath.row == UzantDatumaro.stilo.rawValue {
            novaChelo.accessoryType = .checkmark
        } else {
            novaChelo.accessoryType = .none
        }
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.tintColor = UzantDatumaro.stilo.tintKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        novaChelo.textLabel?.text = KolorStilo(rawValue: indexPath.row)?.nomo
        novaChelo.isAccessibilityElement = true
        novaChelo.accessibilityLabel = novaChelo.textLabel?.text
        
        return novaChelo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UzantDatumaro.stilo.rawValue != indexPath.row {
            let antaua = IndexPath(row: UzantDatumaro.stilo.rawValue, section: 0)
            UzantDatumaro.shanghisStilon(novaStilo: KolorStilo(rawValue: indexPath.row) ?? KolorStilo.Hela)
            tableView.reloadRows(at: [antaua, indexPath], with: .none)
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// Respondi al mediaj shanghoj
extension StiloElektiloViewController {
    
    func didChangePreferredContentSize(notification: NSNotification) -> Void {
        stiloTabelo?.reloadData()
    }
}
