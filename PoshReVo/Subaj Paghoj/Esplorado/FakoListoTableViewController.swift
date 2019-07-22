//
//  FakojTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/21/19.
//  Copyright © 2019 Sinuous Rill. All rights reserved.
//

import UIKit

final class FakoListoTableViewController: BazStilaTableViewController {
    
    private static let chelIdent = "FakojChelIdent"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SeancDatumaro.fakoj.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let novaChelo = tableView.dequeueReusableCell(withIdentifier: FakoListoTableViewController.chelIdent) ?? UITableViewCell()
        
        let fako = SeancDatumaro.fakoj[indexPath.row]
        
        novaChelo.textLabel?.text = fako.nomo
        
        novaChelo.backgroundColor = UzantDatumaro.stilo.bazKoloro
        novaChelo.textLabel?.textColor = UzantDatumaro.stilo.tekstKoloro
        
        return novaChelo
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
