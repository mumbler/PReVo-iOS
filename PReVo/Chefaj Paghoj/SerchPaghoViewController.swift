//
//  SerchPaghoViewController.swift
//  PReVo
//
//  Created by Robin Hill on 3/10/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let serchChelIdent = "serchRezultoChelo"

class SerchPaghoViewController : UIViewController, Subpagho {
    
    @IBOutlet var serchTabulo: UISearchBar?
    @IBOutlet var trovTabelo: UITableView?
    var serchRezultoj = [(String, NSManagedObject)]()
    
    override func viewDidLoad() {
        
        trovTabelo?.delegate = self
        trovTabelo?.dataSource = self
        trovTabelo?.registerClass(UITableViewCell.self, forCellReuseIdentifier: serchChelIdent)
        trovTabelo?.reloadData()
    }
    
    func aranghiNavigaciilo() {
        
        parentViewController?.title = "Serchi"
        
        let dekstraButono = UIBarButtonItem(image: UIImage(named: "pikto_menuo"), style: UIBarButtonItemStyle.Plain, target: self, action: "elektiLingvon")
        dekstraButono.imageInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        parentViewController?.navigationItem.rightBarButtonItem = dekstraButono
    }
}

extension SerchPaghoViewController : UISearchBarDelegate {
    
}

extension SerchPaghoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let novaChelo: UITableViewCell
        if let trovChelo = trovTabelo?.dequeueReusableCellWithIdentifier(serchChelIdent) {
            novaChelo = trovChelo
        } else {
            novaChelo = UITableViewCell()
        }
        
        return novaChelo
    }
}