//
//  EsplorPaghoViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/21/19.
//  Copyright © 2019 Sinuous Rill. All rights reserved.
//

import UIKit

private enum Chelo: Int {
    case Fakoj, IuAjn
    
    public static let kvanto = 2
    
    func titolo() -> String {
        switch self {
        case .Fakoj:
            return NSLocalizedString("esplori fakoj titolo", comment: "")
        case .IuAjn:
            return NSLocalizedString("esplori iu ajn titolo", comment: "")
        }
    }
}

final class EsplorPaghoViewController: BazStilaTableViewController {

    private static let chelIdent = "EsplorPaghoChelIdent"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        efektivigiStilon()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chelo.kvanto
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let novaChelo = tableView.dequeueReusableCell(withIdentifier: EsplorPaghoViewController.chelIdent) ?? UITableViewCell()
        let chelTipo = Chelo(rawValue: indexPath.row)
        
        novaChelo.textLabel?.text = chelTipo?.titolo()
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro

        return novaChelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let chelTipo = Chelo(rawValue: indexPath.row) else {
            return
        }
        
        switch chelTipo {
        case .Fakoj:
            let fakojVC = FakoListoTableViewController(style: .grouped)
            navigationController?.pushViewController(fakojVC, animated: true)
        case .IuAjn:
            let sekva = DatumLegilo.iuAjnArtikolo()
        }
    }
}
