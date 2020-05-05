//
//  BazStilaTableViewController.swift
//  PoshReVo
//
//  Created by Robin Hill on 7/21/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import UIKit

class BazStilaTableViewController: UITableViewController, Stilplena {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        efektivigiStilon()
    }
    
    func efektivigiStilon() {
        tableView.indicatorStyle = UzantDatumaro.stilo.scrollKoloro
        tableView.backgroundColor = UzantDatumaro.stilo.fonKoloro
        tableView.separatorColor = UzantDatumaro.stilo.apartigiloKoloro
        tableView.reloadData()
    }
}
